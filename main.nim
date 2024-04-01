import raylib, random, math
template V:untyped=Vector2
template gm:untyped=getMousePosition()
template f32:untyped=float32
var
    rx=initRand(2005)
    ry=initRand(2024)
    rfi=loadImage("rf.png")
    hx=300'i32
    hy=100'i32
    bx=60'i32
    by=400'i32
    cr=20'f32
    ipm:bool
    hb=true
    bl:f32
    ba:f32
const
    W=850
    H=480
    B=Black
    CW=White
setConfigFlags(flags(Msaa4xHint))
initWindow(850,480,"Mini Code Golf")
setTargetFPS(60)
rfi.imageResize(25,25)
let rf=loadTextureFromImage(rfi)
proc da(x,y,r,n:f32)=drawLine(V(x:x,y:y),V(x:x+(cos(r)*n),y:y-(sin(r)*n)),3.0,Red)
proc db(x,y:int32,sh:bool)=
    if sh:drawPolyLines(V(x:float32 x,y:float32 y),10'i32,40'f32,0'f32,B)
    drawCircle(x,y,10,CW)
proc dh(x,y:int32)=
    drawTexture(rf,x+20-2,y-20,CW)
    drawCircle(x,y,20,B)
proc pb(ipm:var bool,bx,by:var int32,cr,bl,ba:var f32)=
    if (int32(gm.x) in bx-10..bx+10) or ipm:
        ipm=true
        setMouseCursor(PointingHand)
        if isMouseButtonDown(Left):
            drawCircleLines(int32 gm.x,int32 gm.y,cr,CW)
            if isGestureDetected(Drag):
                if cr<60:
                    cr+=sqrt(pow(gm.x-bx.float32,2)+pow(gm.y-by.float32,2))*0.008
                if bl<W/4:
                    bl+=sqrt(pow(gm.x-bx.float32,2)+pow(gm.y-by.float32,2))*0.008
                ba=radToDeg(arctan2((gm.y),(gm.x)))*0.2
        else:
            bx=bx+(cos(ba)*bl).int32
            by=by-(sin(ba)*bl).int32
            ipm=false
            cr=20
            bl=0.0
            ba=0.0
    else:setMouseCursor(Arrow)
while not(windowShouldClose()):
    beginDrawing()
    clearBackground(Lime)
    dh(hx,hy)
    db(bx,by,hb)
    da(float32 bx,float32 by,ba,bl)
    if (getTime().int32 mod 2 == 0) and not(ipm):hb=not(hb)
    pb(ipm,bx,by,cr,bl,ba)
    if bx>=W:bx-=10
    elif bx<=0:bx+=10
    if by>=H:by-=10
    elif by<=0:by+=10
    if checkCollisionCircles(V(x:float32 bx, y:float32 by),10,V(x:float32 hx, y:float32 hy),20):
        clearBackground(B)
        drawText("WELL DONE!",W div 2,H - 50,20,CW)
        drawRectangle((W div 2),(H div 2),200,60,Red)
        drawText("Click To Play Again",(W div 2)+30,(H div 2)+25,15,CW)
        if checkCollisionPointRec(gm,Rectangle(x:(W div 2),y:(H div 2),width:200,height:60)) and isGestureDetected(Tap):
            bx=rx.rand(30..W-30).int32
            by=ry.rand(30..H-30).int32
            hx=rx.rand(30..W-30).int32
            hy=ry.rand(30..H-30).int32
    endDrawing()
closeWindow()
