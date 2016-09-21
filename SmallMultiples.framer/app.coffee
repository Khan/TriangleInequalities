# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: ""
	author: "Andy Matuschak"
	twitter: ""
	description: ""


kaColors = require "kaColors"

canvas = document.createElement "canvas"
canvas.setAttribute("width", "#{Screen.width}px")
canvas.setAttribute("height","#{Screen.height}px")

scaling = 7

container = new Layer
	backgroundColor: ""
	width: Screen.width
	height: Screen.height
container._element.appendChild(canvas)
ctx = canvas.getContext "2d"

drawTriangle = (center, a, b, angle, includeLabels) =>
	ctx.strokeStyle = kaColors.math1
	ctx.beginPath()
	
	width = Math.cos(angle) * b
	height = Math.sin(angle) * a
	
	# Move to A.B
	vertexAB = {x: center.x - b/2, y: center.y + a/2}
	ctx.moveTo(vertexAB.x, vertexAB.y)
	# Move to A.C
	vertexAC = {x: center.x - b/2 + Math.cos(angle) * a, y: center.y + a/2 - Math.sin(angle) * a}
	ctx.lineTo(vertexAC.x, vertexAC.y)
	# Move to B.C
	vertexBC = {x: center.x + b/2, y: center.y + a/2}
	ctx.lineTo(vertexBC.x, vertexBC.y)
	ctx.closePath()
	ctx.stroke()
	
	# Draw vertex dots.
	radius = 2.5
	ctx.fillStyle = ctx.strokeStyle
	ellipseAt = (point) ->
		ctx.beginPath()
		ctx.ellipse(point.x, point.y, radius, radius, 0, 0, 2 * Math.PI)
		ctx.fill()
	ellipseAt vertexAB
	ellipseAt vertexAC
	ellipseAt vertexBC
	
	ctx.fillStyle = kaColors.math3
	ctx.font = "16px serif"
	ctx.textAlign = "center"
	text = if includeLabels then "#{a / scaling}" else "a"
	# Lazy cross product ahoy!
	ctx.fillText(text, (vertexAB.x + vertexAC.x) / 2 - Math.abs(Math.cos(angle + Math.PI/2) * 20), (vertexAB.y + vertexAC.y) / 2 - Math.sin(angle + Math.PI/2) * 18)

	ctx.fillStyle = kaColors.math3
	ctx.textAlign = "center"
	text = if includeLabels then "#{b / scaling}" else "b"
	measure = ctx.measureText(text)
	ctx.fillText(text, center.x, center.y + a / 2 + 18)

baseA = 5
baseB = 5
angle = 70.0 * Math.PI / 180.0

draw = ->
	ctx.clearRect(0, 0, Screen.width, Screen.height)
	for x in [0..7]
		for y in [0..5]
			drawTriangle({x: 100 + x*150, y: 50 + y*110}, (baseA + x) * scaling, (baseB + y) * scaling, angle, true)
			
	drawTriangle({x: Screen.width / 2, y: Screen.height - 75}, scaling * 7, scaling * 8, angle, false)
	
draw()

container.on Events.Pan, (event) ->
	angle = Math.atan2((Screen.height - 75) - event.point.y, event.point.x - Screen.width/2)
	draw()
	
