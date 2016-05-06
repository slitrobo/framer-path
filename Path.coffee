class exports.Path extends Layer	

	path = []; animating = []; point = []; animate = []; quadratic = []; bezier = []; close = []
	animations = points = 0
	

	
	constructor: (options) ->
		
		
		options = _.defaults options,
		
			@pointVisible = @handleVisible = false
			
			@pointSize = 4
			@handleSize = 2
			@strokeWidth = 1
			
			@pointColor = @handleColor = @strokeColor= "white"

			@fill
			
			@path = 
				
				animationOptions: {time:1; curve:"bezier-curve"}
				
				draggable: false
				
				
				
				point: (p) =>

					
					point[points] = new Layer
							name: "Point #"+points
							backgroundColor: @pointColor
							superLayer: @
							width: @pointSize
							height: @pointSize
							borderRadius: @pointSize/2
							x: p.x - @pointSize/2
							y: p.y - @pointSize/2
							
					animate[points] = new Animation
					
				 if @pointVisible == false
						point[points].opacity = 0
						
				 if @path.draggable == true
						point[points].draggable = true
						
				 if p.quadratic == "first" or p.bezier == "first" or p.bezier == "second"
				 		point[points].name = "Point #"+points+" (handle)"
				 		point[points].backgroundColor = @handleColor
				 		point[points].width = @handleSize
				 		point[points].height = @handleSize
				 		
				 		if @handleVisible == false
				 			point[points].opacity = 0

					if p.states != undefined
						
						animations = points
						
						
						if Array.isArray(p.states.x) && Array.isArray(p.states.y)
											
							for i in [0...p.states.x.length]
								
								cx = p.states.x
								cy = p.states.y
								

								point[points].states.add
									"array #{i}":
											x: cx[i]
											y: cy[i]
											
							
						if Array.isArray(p.states.x)==false && Array.isArray(p.states.y)==false							
							point[points].states.add
									second:
										x: p.states.x
										y: p.states.y
							
							animate[points] = new Animation
								layer: point[points]
								properties:
									x: p.states.x
									y: p.states.y
								time: @.path.animationOptions.time
								curve: @.path.animationOptions.curve

							
									
							
	
						
						# In case if not both values are arrays	
						if Array.isArray(p.states.x) && Array.isArray(p.states.y)==false
							print "Y values are not an array"
						
						if Array.isArray(p.states.x)==false && Array.isArray(p.states.y)
							print "X values are not an array"
				

					
				 	point[points].states.animationOptions = @path.animationOptions
				 
				 					 	
					if p.quadratic == undefined && p.bezier != "first"
						 quadratic[points] = false
						 bezier[points] = false
						 
						 if p.close == true
						 	path.push('L'+p.x)
						 	close[points] = true
						 else
						 	path.push(p.x)	
						 
				 
				 	if p.quadratic == "first"	
				 		bezier[points] = false
				 		
				 		quadratic[points] = true
				 		path.push('Q'+p.x)
				 		
				 	if p.bezier == "first"
				 		quadratic[points] = false
				 		
				 		bezier[points] = true
				 		path.push('C'+p.x)
	
					
					path.push(p.y)
					
# 					print points+": "+quadratic[points]
					
					@html = svgStart + pathBegin + path + pathEnd + svgEnd
					
					
					points++
				
					
				animate: (t) =>
				
				
					for i in[0...point.length]
						if t == undefined || t == "states"
							point[i].states.next()
						else
							animate[i].start()
 					
 						
						execute = =>
						
 							
							for i in [0...point.length]
						
								
								c = i+i
								
								

								animating[c] = point[i].x + @pointSize/2
								
								if quadratic[i] == true
									animating[c] = "Q" + animating[c]
									
								if bezier[i] == true
									animating[c] = "C" + animating[c]
									
								if close[i] == true
									animating[c] = "L" + animating[c]
								
								animating[c+1] = point[i].y + @pointSize/2
								

							
							@html = svgStart + pathBegin + animating + pathEnd + svgEnd			
# 							print @html
		
					for i in[0...point.length]
							point[i].on 'change:point', => 
								execute()
							
						
					

			
				quadratic: (p) =>
				
					if p.states != undefined
						handle =
							x: p.x
							y: p.y
							states: 
								x: p.states.x
								y: p.states.y
							quadratic: "first"
						
						quadraticPoint =
							x: p.qx
							y: p.qy
							states: 
								x: p.states.qx
								y: p.states.qy
		
					else
						handle =
							x: p.x
							y: p.y
							quadratic: "first"
							
						quadraticPoint =
							x: p.qx
							y: p.qy
		
					
					
					@path.point(handle)
					@path.point(quadraticPoint)
					
		
					

				cubic: (p) =>
					
					if p.states != undefined
					
						handleOne = 
							x: p.cx1
							y: p.cy1
							states:
								x: p.states.cx1
								y: p.states.cy1
							bezier: "first"
							
						handleTwo = 
							x: p.cx2
							y: p.cy2
							states:
								x: p.states.cx2
								y: p.states.cy2
							bezier: "second"
							
						bezierPoint =
							x: p.x
							y: p.y
							states:
								x: p.states.x
								y: p.states.y
					else
						handleOne = 
							x: p.cx1
							y: p.cy1
							bezier: "first"
							
						
						handleTwo = 
							x: p.cx2
							y: p.cy2
							bezier: "second"
							
						bezierPoint =
							x: p.x
							y: p.y
							
						
					@path.point(handleOne)
					@path.point(handleTwo)	
					@path.point(bezierPoint)				
					
				close: (p) =>
					p.close = true
					@path.point(p)
					
					
					
						
			
		super options
		
		svgStart = '<svg height="'+@height+'" width="'+@width+'" stroke='+@strokeColor+' stroke-width="'+@strokeWidth+'" fill="'+@fill+'">'
		pathBegin = '<path d="M'
		pathEnd = '">'
		svgEnd = '</svg>'	
	
		
		
		
	@define "path.animationOptions",
		get: -> @_path.animationOptions
		set: (value) -> 
			@_path.animationOptions = value
		
	@define "path.draggable",
		get: -> @_path.draggable
		set: (value) -> 
			@_path.draggable = value
		
	@define "pointVisible",
		get: -> @_pointVisible
		set: (value) -> 
			@_pointVisible = value
			
	@define "handleVisible",
		get: -> @_handleVisible
		set: (value) -> 
			@_handleVisible = value
			
	@define "pointSize",
		get: -> @_pointSize
		set: (value) -> 
			@_pointSize = value
			
	@define "handleSize",
		get: -> @_handleSize
		set: (value) -> 
			@_handleSize = value
			
	@define "pointColor",
		get: -> @_pointColor
		set: (value) -> 
			@_pointColor = value
			
	@define "handleColor",
		get: -> @_handleColor
		set: (value) -> 
			@_handleColor = value
			
	@define "strokeColor",
		get: -> @_strokeColor
		set: (value) -> 
			@_strokeColor = value
			
	@define "strokeWidth",
		get: -> @_strokeWidth
		set: (value) -> 
			@_strokeWidth = value
		
	@define "fill",
		get: -> @_fill
		set: (value) -> 
			@_fill = value