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

# Created: 2017.11.15
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav <shabbychef@gmail.com>
# Comments: Steven E. Pav


#' @title decagon_maze .
#'
#' @description 
#'
#' Draw a regular decagon maze, with each side consisting of
#' of \eqn{2^{depth}} pieces of length \code{unit_len}. 
#'
#' @details
#'
#' Draws a maze in a regular decagon...
#'
#' @keywords plotting
#' @template etc
#' @template param-unitlen
#' @template param-clockwise
#' @template param-start-from
#' @template param-end-side
#' @template param-boundary-stuff
#' @template return-none
#' @param depth the depth of recursion. This controls the side length.
#'
#' @param method there are many ways to recursively draw an decagon. 
#' The following values are acceptable:
#' \describe{
#' \item{random}{Hobson's choice.}
#' }
#'
#' @examples 
#' \dontrun{
#' turtle_init(2200,2200,mode='clip')
#' turtle_hide()
#' turtle_up()
#' turtle_do({
#'   turtle_setpos(25,1100)
#'   turtle_setangle(0)
#' 	decagon_maze(5,21,draw_boundary=TRUE,boundary_holes=c(1,6))
#' })
#' }
#' @export
decagon_maze <- function(depth,unit_len=4L,clockwise=TRUE,start_from=c('midpoint','corner'),
												 method=c('ten_rhombs'),
												 draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,boundary_holes=NULL,boundary_hole_color=NULL,
												 end_side=1) {
	method <- match.arg(method)
	start_from <- match.arg(start_from)
	num_segs <- round(2^depth)

	multiplier <- ifelse(clockwise,1,-1)
	if (start_from=='midpoint') { turtle_backward(distance=unit_len * num_segs/2) }

	nsides <- 10
	outang <- (180 * (nsides-2)) / nsides
	inang <- 180 - outang


	switch(method,
				 ten_rhombs={
					 .turn_right(multiplier * inang)

					 starts <- c(1,1,2,3,3,4,5,5,6,7,7,8,9,9,10)
					 ends   <- c(10,2,10,2,4,2,4,6,4,6,8,6,8,10,8)
					 which_holes <- .span_tree(starts,ends)

					 # 
					 inner_lines <- rep(c(TRUE,TRUE,FALSE,FALSE,
																FALSE,FALSE,FALSE,TRUE),5)
					 inner_holes <- rep(FALSE,length(inner_lines))
					 inner_holes[which(inner_lines)[which_holes]] <- TRUE

					 turn_angles <- rep(c(inang, 180 - (2*inang)),5)
					 end_sides   <- rep(c(2, 2),5)
					 flipflop    <- !clockwise
					 for (iii in seq_along(turn_angles)) {
						 myidx <- (1:4) + (iii-1) * 4 
						 parallelogram_maze(unit_len,height=num_segs,width=num_segs,angle=turn_angles[iii],clockwise=flipflop,
																start_from='corner',
																draw_boundary=TRUE,num_boundary_holes=NULL,
																boundary_lines=inner_lines[myidx],
																boundary_holes=inner_holes[myidx],
																end_side=end_sides[iii])
						 flipflop <- !flipflop
					 }
					 .turn_left(multiplier * inang)
	})
	if (draw_boundary) {
		holes <- .interpret_boundary_holes(boundary_holes,num_boundary_holes,nsides=nsides)
		boundary_lines <- .interpret_boundary_lines(boundary_lines,nsides=nsides)

		holey_path(unit_len=unit_len,
							 lengths=rep(num_segs,nsides),
							 angles=multiplier * inang,
							 draw_line=boundary_lines,
							 has_hole=holes,
							 hole_color=boundary_hole_color)
	}
	# move to ending side
	if ((end_side != 1) && (!is.null(end_side))) {
		for (iii in 1:(end_side-1)) {
			turtle_forward(distance=unit_len * num_segs)
			.turn_right(multiplier * inang)
		}
	}
	if (start_from=='midpoint') { turtle_forward(distance=unit_len * num_segs/2) }
}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r