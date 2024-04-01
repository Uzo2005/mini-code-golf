import raylib, random, math

var
    rx = initRand(2005)
    ry = initRand(2024)
const
    windowWidth = 850
    windowHeight = 480
    fieldColor = Lime
    flagSize = 25
    wallSize = 50
    wallColor = getColor(0x0C0A09FF)
    ballRadius = 10
    holeRadius = 20
    originalControlRadius = ballRadius * 2
    maxControlRadius = originalControlRadius * 3

setConfigFlags(flags(Msaa4xHint))

initWindow(windowWidth, windowHeight, "Mini Code Golf")
setTargetFPS(60)

var redflagImage = loadImage("./red_flag.png")

redflagImage.imageResize(flagSize, flagSize)

let redflag = loadTextureFromImage(redflagImage)

proc drawArrow(x, y, r, n: float32) =
    drawLine(
        Vector2(x: x, y: y), Vector2(x: x + (cos(r) * n), y: y - (sin(r) * n)), 3.0, Red
    )

proc drawBall(x, y: int32, showHighlight: bool) =
    if showHighlight:
        drawPolyLines(
            Vector2(x: float32 x, y: float32 y),
            10'i32,
            float32 ballRadius * 4,
            0'f32,
            Black,
        )

    drawCircle(x, y, ballRadius, White)

proc drawHole(x, y: int32) =
    drawTexture(redflag, x + holeRadius - 2, y - holeRadius, White)
    drawCircle(x, y, holeRadius, Black)

proc playBall(
        inPlayMode: var bool,
        ballX, ballY: var int32,
        controlRadius, ballShowLine, ballAngle: var float32,
) =
    if (int32(getMousePosition().x) in ballX - ballRadius .. ballX + ballRadius) or
            inPlayMode:
        inPlayMode = true
        setMouseCursor(PointingHand)
        if isMouseButtonDown(Left):
            drawCircleLines(
                int32 getMousePosition().x,
                int32 getMousePosition().y,
                controlRadius,
                White,
            )
            if isGestureDetected(Drag):
                if controlRadius < maxControlRadius:
                    controlRadius +=
                        sqrt(
                            pow(getMousePosition().x - ballX.float32, 2) +
                                pow(getMousePosition().y - ballY.float32, 2)
                        ) * 0.008

                if ballShowLine < float32((windowWidth) / 4):
                    ballShowLine +=
                        sqrt(
                            pow(getMousePosition().x - ballX.float32, 2) +
                                pow(getMousePosition().y - ballY.float32, 2)
                        ) * 0.008

                ballAngle =
                    radToDeg(arctan2((getMousePosition().y), (getMousePosition().x))) *
                    0.2

        else:
            ballX = ballX + (cos(ballAngle) * ballShowLine).int32
            ballY = ballY - (sin(ballAngle) * ballShowLine).int32
            inPlayMode = false
            controlRadius = originalControlRadius
            ballShowLine = 0.0
            ballAngle = 0.0
    else:
        setMouseCursor(Arrow)

var
    holeX: int32 = 300
    holeY: int32 = 100
    ballX: int32 = 60
    ballY: int32 = 400
    controlRadius: float32 = originalControlRadius
    inPlayMode: bool
    highLightBall = true
    ballShowLine: float32
    ballAngle: float32

while not (windowShouldClose()):
    beginDrawing()
    clearBackground(fieldColor)
    drawHole(holeX, holeY)
    drawBall(ballX, ballY, highLightBall)
    drawArrow(float32 ballX, float32 ballY, (ballAngle), ballShowLine)

    if (int32(getTime()) mod 2 == 0) and not (inPlayMode):
        highLightBall = not (highLightBall)

    playBall(inPlayMode, ballX, ballY, controlRadius, ballShowLine, ballAngle)

    if ballX >= windowWidth:
        ballX -= 10
    elif ballX <= 0:
        ballX += 10

    if ballY >= windowHeight:
        ballY -= 10
    elif ballY <= 0:
        ballY += 10

    if checkCollisionCircles(
        Vector2(x: ballX.float32, y: ballY.float32),
        ballRadius,
        Vector2(x: holeX.float32, y: holeY.float32),
        holeRadius,
    ):
        clearBackground(Black)
        drawText(" WELL DONE! ", windowWidth div 2, windowHeight - 50, 20, RayWhite)
        drawRectangle((windowWidth div 2), (windowHeight div 2), 200, 60, Red)
        drawText(
            "Click To Play Again",
            (windowWidth div 2) + 30,
            (windowHeight div 2) + 25,
            15,
            RayWhite,
        )

        if checkCollisionPointRec(
            getMousePosition(),
            Rectangle(
                x: (windowWidth div 2), y: (windowHeight div 2), width: 200, height: 60
            ),
        ) and isGestureDetected(Tap):
            ballX = rx.rand(30 .. windowWidth - 30).int32
            ballY = ry.rand(30 .. windowHeight - 30).int32
            holeX = rx.rand(30 .. windowWidth - 30).int32
            holey = ry.rand(30 .. windowHeight - 30).int32

    endDrawing()

closeWindow()
