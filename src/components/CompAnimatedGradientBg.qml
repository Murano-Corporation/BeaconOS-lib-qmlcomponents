import QtQuick 2.0
import QtMultimedia 5.12

Comp__BASE {
    id: compAnimatedGradientBgRoot

    anchors.fill: parent

    Rectangle{
        anchors.fill: parent

        color: "black"
    }

    property bool showAnimatedGradient: Settings.gfxShowAnimatedBg

    Video{
        id: videoSource

        anchors.fill: parent

        property int indexLoopAt: Settings.gfxAnimBgLoopAtIndex
        property int indexLoopTo: Settings.gfxAnimBgLoopToIndex
        property double configPlaybackRate: Settings.animatedGradientPlaybackRate


        source: "file://" + GlobalConstants.videoPath + "Gradient_4K.mp4"

        autoPlay: true
        autoLoad: true
        playbackRate: configPlaybackRate > 0 ? configPlaybackRate : 1.0

        onPositionChanged: {
            //console.log("Position now: " + position)

            if(position >= indexLoopAt)
            {

                videoSource.seek(indexLoopTo)
            }
        }

        //onErrorChanged: {
        //    console.log("Video Error Now: " + errorString)
        //}
        //
        //onAvailabilityChanged: {
        //    console.log("Video Availability now: " + availability)
        //}
        //
        //onBufferProgressChanged: {
        //    console.log("Video Buffer Progress now: " + bufferProgress)
        //}
        //
        //
        //onStatusChanged: {
        //    console.log("Video status now: " + status)
        //
        //    if(status === MediaPlayer.EndOfMedia)
        //    {
        //        console.log("...End of media")
        //    }
        //}

        //onPlaybackStateChanged: {
        //    console.log("Video playback state now: " + playbackState)
        //
        //    if(playbackState === MediaPlayer.PlayingState)
        //    {
        //        console.log("...Playing")
        //    }
        //
        //    if(playbackState === MediaPlayer.PausedState )
        //    {
        //        console.log("...Paused. Playing...")
        //        videoSource.play()
        //    }
        //
        //    if(playbackState === MediaPlayer.StoppedState)
        //    {
        //        console.log("...Stopped")
        //        videoSource.seek(1)
        //        videoSource.play()
        //    }
        //}

        //onPlaybackRateChanged:  {
        //    console.log("Video playback rate now: " + playbackRate)
        //}
    }


}


//    property point ptTL: Qt.point(192.0, 108.0)
//    property point ptTR: Qt.point(compAnimatedGradientBgRoot.width - 192.0, 108.0)
//    property point ptBR: Qt.point(compAnimatedGradientBgRoot.width - 192.0, compAnimatedGradientBgRoot.height - 108.0)
//    property point ptBL: Qt.point(192.0, compAnimatedGradientBgRoot.height - 108.0)

//    property color colorBG: "#101C29";
//    property color color1: "#2C2F40"
//    property color color2: "#080A12"
//    property color color3: "#080B16"
//    property color color4: "#122D3B"

//    property real blurOpacity: 0.65
//    property real blurRadius: 400
//    property int durationBetweenPoints: 15000;
//    property int blurSamples: 8
//    property bool blurTransparentBorder: true
//    property real halfWidth: parent.height * 0.5




//    Rectangle{
//        id: rectBg

//        anchors.fill: parent

//        color:compAnimatedGradientBgRoot.colorBG
//    }

//    Item{
//        id: groupBlobs
//        clip: true
//        anchors.fill: parent
//        opacity: compAnimatedGradientBgRoot.blurOpacity
//        Rectangle{
//            id: rectBlob0
//            visible: false
//            height: parent.height
//            width: height

//            x: compAnimatedGradientBgRoot.ptTL.x - (halfWidth)
//            y: compAnimatedGradientBgRoot.ptTL.y - (halfWidth)

//            radius: 0.5 * height

//            color: compAnimatedGradientBgRoot.color1
//        }



//        GaussianBlur{
//            id: blur0

//            source: rectBlob0
//            cached: true
//            anchors.fill: rectBlob0

//            radius: compAnimatedGradientBgRoot.blurRadius
//            samples: compAnimatedGradientBgRoot.blurSamples
//            transparentBorder: blurTransparentBorder
//        }

//        Rectangle{
//            id: rectBlob1

//            visible:  false

//            height: parent.height
//            width: height

//            x: compAnimatedGradientBgRoot.ptTR.x
//            y: compAnimatedGradientBgRoot.ptTR.y - (halfWidth)

//            radius: 0.5 * height

//            color: compAnimatedGradientBgRoot.color2
//        }

//        GaussianBlur{
//            id: blur1
//            source: rectBlob1
//            cached: true
//            anchors.fill: rectBlob1

//            radius: compAnimatedGradientBgRoot.blurRadius
//            samples: compAnimatedGradientBgRoot.blurSamples
//            transparentBorder: blurTransparentBorder

//            antialiasing: true
//            smooth: true
//        }

//        Rectangle{
//            id: rectBlob2

//            visible: false

//            height: parent.height
//            width: height

//            x: compAnimatedGradientBgRoot.ptBL.x - (halfWidth)
//            y: compAnimatedGradientBgRoot.ptBL.y - (halfWidth)

//            radius: 0.5 * height

//            color: compAnimatedGradientBgRoot.color3
//        }

//        GaussianBlur{
//            id:blur2
//            source: rectBlob2
//            cached: true
//            anchors.fill: rectBlob2

//            radius: compAnimatedGradientBgRoot.blurRadius
//            samples: compAnimatedGradientBgRoot.blurSamples
//            transparentBorder: blurTransparentBorder

//            antialiasing: true
//            smooth: true
//        }

//        Rectangle{
//            id: rectBlob3

//            visible: false

//            height: parent.height
//            width: height

//            x: compAnimatedGradientBgRoot.ptBR.x
//            y: compAnimatedGradientBgRoot.ptBR.y - (halfWidth)

//            radius: 0.5 * height

//            color: compAnimatedGradientBgRoot.color4
//        }

//        GaussianBlur{
//            id: blur3
//            source: rectBlob3

//            anchors.fill: rectBlob3
//            cached: true
//            radius: compAnimatedGradientBgRoot.blurRadius
//            samples: compAnimatedGradientBgRoot.blurSamples
//            transparentBorder: blurTransparentBorder

//            antialiasing: true
//            smooth: true
//        }



//    }

//    //Rectangle{
//    //  height: 10
//    //  width: height
//    //
//    //  color: "green"
//    //
//    //  x: ptTR.x
//    //  y: ptTR.y
//    //}



//    SequentialAnimation{

//        running: true
//        loops: Animation.Infinite

//        ParallelAnimation{

//            NumberAnimation{
//                target: rectBlob0
//                property: "x"
//                to: ptTR.x
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob0
//                property: "y"
//                to: ptTR.y - halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob1
//                property: "x"
//                to: ptBL.x- halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob1
//                property: "y"
//                to: ptBL.y- halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob2
//                property: "x"
//                to: ptBR.x
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob2
//                property: "y"
//                to: ptBR.y - halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob3
//                property: "x"
//                to: ptTL.x- halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob3
//                property: "y"
//                to: ptTL.y- halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }
//        }

//        ParallelAnimation{

//            NumberAnimation{
//                target: rectBlob0
//                property: "x"
//                to: ptBR.x
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob0
//                property: "y"
//                to: ptBR.y- halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob1
//                property: "x"
//                to: ptTL.x- halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob1
//                property: "y"
//                to: ptTL.y- halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob2
//                property: "x"
//                to: ptBL.x- halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob2
//                property: "y"
//                to: ptBL.y- halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob3
//                property: "x"
//                to: ptTR.x
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob3
//                property: "y"
//                to: ptTR.y- halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }
//        }

//        ParallelAnimation{

//            NumberAnimation{
//                target: rectBlob0
//                property: "x"
//                to: ptTL.x- halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob0
//                property: "y"
//                to: ptTL.y- halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob1
//                property: "x"
//                to: ptTR.x
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob1
//                property: "y"
//                to: ptTR.y- halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob2
//                property: "x"
//                to: ptBL.x- halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob2
//                property: "y"
//                to: ptBL.y- halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob3
//                property: "x"
//                to: ptBR.x
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }

//            NumberAnimation{
//                target: rectBlob3
//                property: "y"
//                to: ptBR.y- halfWidth
//                duration: compAnimatedGradientBgRoot.durationBetweenPoints
//            }
//        }

//    }

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.25;height:1080;width:1920}
}
##^##*/
