# Copyright 2017-2017 Steven E. Pav. All Rights Reserved.
# Author: Steven E. Pav
#
# This file is part of mazealls.
#
# mazealls is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# mazealls is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with mazealls.  If not, see <http://www.gnu.org/licenses/>.

# Created: 2017.11.04
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav <shabbychef@gmail.com>
# Comments: Steven E. Pav

#' @title hexagon_maze .
#'
#' @description 
#' 
#' Recursively draw a regular hexagon, with sides consisting
#' of \eqn{2^depth} pieces of length \code{unit_len}.
#'
#' @details
#'
#' @keywords plotting
#' @template etc
#' @template param-unitlen
#' @template param-clockwise
#' @template param-start-from
#' @template param-end-side
#' @template param-boundary-stuff
#' @template return-none
#' @param depth the depth of recursion. This controls the
#' side length. If an integer then nice recursive mazes
#' are possible, but non-integral values corresponding to
#' log base 2 of integers are also acceptable.
#' @param method there are many ways to recursive draw an isosceles
#' trapezoid.  The following values are acceptable:
#' \describe{
#' \item{two_trapezoids}{Two isosceles trapezoids are placed next to each
#' other, with a holey line between them.}
#' \item{size_triangles}{Six equilateral triangles are packed together, with
#' five holey lines and one solid line.}
#' \item{three_parallelograms}{Three parallelograms are packed together,
#' with two holey lines and one solid line between them.}
#' \item{random}{A method is chosen uniformly at random.}
#' }
#' @examples
#' \dontrun{
#' turtle_init(2000,2000)
#' turtle_hide()
#' turtle_do({
#' 	turtle_up()
#' 	turtle_backward(250)
#' 	.turn_right(90)
#' 	turtle_forward(150)
#' 	.turn_left(90)
#' 
#' 	.turn_right(60)
#' 	hexagon_maze(depth=5,12,clockwise=FALSE,method='six_triangles',draw_boundary=TRUE,boundary_holes=c(1,4),boundary_hole_color='green')
#' })
#' 
#' 
#' turtle_init(2000,2000)
#' turtle_hide()
#' turtle_do({
#' 	turtle_up()
#' 	turtle_backward(250)
#' 	.turn_right(90)
#' 	turtle_forward(150)
#' 	.turn_left(90)
#' 
#' 	.turn_right(60)
#' 	hexagon_maze(depth=log2(20),12,clockwise=FALSE,method='six_triangles',draw_boundary=TRUE,boundary_holes=c(1,4),boundary_hole_color='green')
#' })
#' 
#' 
#' turtle_init(1000,1000)
#' turtle_hide()
#' turtle_do({
#' 	turtle_up()
#' 	turtle_backward(250)
#' 	.turn_right(90)
#' 	turtle_forward(150)
#' 	.turn_left(90)
#' 
#' 	.turn_right(60)
#' 	hexagon_maze(depth=5,12,clockwise=FALSE,method='three_parallelograms',draw_boundary=TRUE,boundary_holes=c(1,4),boundary_hole_color='green')
#' })
#'
#' turtle_init(1000,1000)
#' turtle_hide()
#' turtle_do({
#' 	hexagon_maze(depth=4,15,clockwise=TRUE,method='two_trapezoids',draw_boundary=TRUE,boundary_holes=c(1,4))
#' 	hexagon_maze(depth=4,15,clockwise=FALSE,method='two_trapezoids',draw_boundary=TRUE,boundary_lines=c(2,3,4,5,6),boundary_holes=c(1,4))
#' })
#'
#' turtle_init(1000,1000)
#' turtle_hide()
#' turtle_do({
#' 	depth <- 4
#' 	num_segs <- 2^depth
#' 	unit_len <- 8
#' 	multiplier <- -1
#' 	hexagon_maze(depth=depth,unit_len,clockwise=FALSE,method='two_trapezoids',draw_boundary=FALSE)
#' 	for (iii in c(1:6)) {
#' 		if (iii %in% c(1,4)) {
#' 			holes <- c(1,4) 
#' 		} else {
#' 			holes <- c(1)
#' 		}
#' 		hexagon_maze(depth=depth,unit_len,clockwise=TRUE,method='two_trapezoids',draw_boundary=TRUE,boundary_holes=holes)
#' 		turtle_forward(dist=unit_len * num_segs/2)
#' 		.turn_right(multiplier * 60)
#' 		turtle_forward(dist=unit_len * num_segs/2)
#' 	}
#' })
#'
#' }
#' @export
hexagon_maze <- function(depth,unit_len,clockwise=TRUE,method=c('two_trapezoids','six_triangles','three_parallelograms','random'),
												 start_from=c('midpoint','corner'),
												 draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,boundary_holes=NULL,boundary_hole_color=NULL,
												 end_side=1) {
	
	method <- match.arg(method)
	start_from <- match.arg(start_from)

	if (start_from=='corner') { turtle_forward(dist=unit_len * num_segs/2) }

	# check for off powers of two
	num_segs <- round(2^depth)
	multiplier <- ifelse(clockwise,1,-1)

	if (depth > 1) {
		turtle_up()
		my_method <- switch(method,
												random={
													sample(c('two_trapezoids','six_triangles','three_parallelograms'),1)
												},
												method)
		switch(my_method,
					 two_trapezoids={
						 magic_ratio <- sqrt(3) / 4

						 .turn_right(multiplier * 90)
						 turtle_forward(2*num_segs * unit_len * magic_ratio)
						 .turn_left(multiplier * 90)
						 iso_trapezoid_maze(depth,unit_len,clockwise=clockwise,
																start_from='midpoint',
																draw_boundary=TRUE,boundary_lines=c(1),boundary_holes=c(1))
						 iso_trapezoid_maze(depth,unit_len,clockwise=!clockwise,draw_boundary=FALSE)
						 
						 .turn_left(multiplier * 90)
						 turtle_forward(2*num_segs * unit_len * magic_ratio)
						 .turn_right(multiplier * 90)
					 },
					 six_triangles={
						 turtle_backward(dist=unit_len * num_segs/2) 
						 bholes <- sample.int(n=6,size=5)
						 for (iii in c(1:6)) {
							 eq_triangle_maze(depth,unit_len,clockwise=clockwise,method='random',draw_boundary=TRUE,
																start_from='corner',
																boundary_lines=2,boundary_holes=iii %in% bholes)
							 turtle_forward(dist=unit_len * num_segs) 
							 .turn_right(multiplier*60)
						 }
						 turtle_forward(dist=unit_len * num_segs/2) 
					 },
					 three_parallelograms={
						 bholes <- sample.int(n=3,size=2)
						 for (iii in 1:3) {
							 parallelogram_maze(unit_len,num_segs,num_segs,angle=60,clockwise=clockwise,
																	draw_boundary=TRUE,boundary_lines=3,num_boundary_holes=0,boundary_holes=iii %in% bholes)
							 turtle_forward(num_segs * unit_len / 2)
							 .turn_right(multiplier * 60)
							 turtle_forward(num_segs * unit_len)
							 .turn_right(multiplier * 60)
							 turtle_forward(num_segs * unit_len / 2)
						 }
					 })
	}
	if (draw_boundary) {
		holes <- .interpret_boundary_holes(boundary_holes,num_boundary_holes,nsides=6)
		boundary_lines <- .interpret_boundary_lines(boundary_lines,nsides=6)

		turtle_backward(dist=unit_len * num_segs/2)

		holey_path(unit_len=unit_len,
							 lengths=rep(num_segs,6),
							 angles=multiplier*60,
							 draw_line=boundary_lines,
							 has_hole=holes,
							 hole_color=boundary_hole_color)
		turtle_forward(dist=unit_len * num_segs/2)
	}
	if ((end_side != 1) && (!is.null(end_side))) {
		for (iii in 1:(end_side-1)) {
			turtle_forward(dist=unit_len * num_segs/2)
			.turn_right(multiplier * 60)
			turtle_forward(dist=unit_len * num_segs/2)
		}
	}
	if (start_from=='corner') { turtle_backward(dist=unit_len * num_segs/2) }
}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r