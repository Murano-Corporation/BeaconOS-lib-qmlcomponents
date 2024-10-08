import QtQuick 2.15
import QtQuick.Controls 2.15
import SystemControllers 1.0
import QtMultimedia 5.15

Comp__BASE {
    id: compAudioVideoPlayer

    property string startingFileURL: testSample_Video_MP4

    readonly property string testSample_Audio_MP3: "file:///home/murano/Music/sample-3s.mp3"
    readonly property string testSample_Audio_WAV: "file:///home/murano/Music/sample-3s.wav"
    readonly property string testSample_Video_MP4: "file:///home/murano/Videos/sample-5s.mp4"
    readonly property string imagePath_Play: imageLocation + "PlayCircle.svg"
    readonly property string imagePath_Pause: imageLocation + "Help.svg"
    readonly property string imagePath_Rewind: imageLocation + "Left.svg"
    readonly property string imagePath_FastForward: imageLocation + "Right.svg"
    readonly property string imagePath_JumpForward: imageLocation + "DoubleRight.svg"
    readonly property string imagePath_JumpBack: imageLocation + "DoubleLeft.svg"
    readonly property string imagePath_RotateLeft: imageLocation + "Help.svg"
    readonly property string imagePath_RotateRight: imageLocation + "Help.svg"
    readonly property string imagePath_Close: imageLocation + "CancelFill.svg"
    readonly property string imagePath_Muted: imageLocation + "Help.svg"
    readonly property string imagePath_Unmuted: imageLocation + "Help.svg"
    readonly property string imagePath_Menu: imageLocation + "HamburgerMenu.svg"

    readonly property color colorAreaFileInfoBg: "#101010"
    readonly property color colorAreaControlsBg: "#101010"
    readonly property color colorAreaContentBg: "#000000"
    readonly property color colorControlIdle: "#9287ED"
    readonly property color colorControlPressed: Qt.darker(colorControlIdle)
    readonly property color colorControlActive: Qt.lighter(colorControlIdle)
    readonly property color colorPlaybackPosInfo: "#80ffffff"

    readonly property int areaHeightControls: 90
    readonly property int controlBtnHeight: 60
    readonly property int controlBtnHeight_Small: 45

    readonly property var fileInfo: audioVideoController.strAudioVideoFileInfo

    readonly property bool autoHideControls: true

    property bool userMuted: false

    signal closePressed

    clip: true

    function onClosePressed() {
        videoController.stop()
        compAudioVideoPlayer.closePressed()
    }

    Component.onCompleted: {
        videoController.source = startingFileURL
    }

    AudioVideoController {
        id: audioVideoController
    }

    Rectangle {
        id: rectAreaFileInfo

        color: compAudioVideoPlayer.colorAreaFileInfoBg
        height: 32
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }
    }

    Rectangle {
        id: rectAreaContents

        color: compAudioVideoPlayer.colorAreaContentBg
        anchors {
            top: rectAreaFileInfo.bottom
            left: parent.left
            right: parent.right
            bottom: rectAreaControls.top
        }
    }

    Rectangle {
        id: rectAreaControls

        color: compAudioVideoPlayer.colorAreaControlsBg
        height: compAudioVideoPlayer.areaHeightControls
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
    }

    Video {
        id: videoController

        readonly property var playbackSpeeds: [0.25, 0.5, 0.75, 1.0, 1.1, 1.25, 1.5, 1.75]
        readonly property var orientationValues: [0, 90, 180, 270, 360]
        readonly property bool canRewind: playbackSpeedIndex > 0
        readonly property bool canfastforward: playbackSpeedIndex < playbackSpeeds.length
        readonly property int playbackSpeedNormalIndex: 3
        readonly property int seekInterval_Small: 250
        readonly property int seekInterval_Large: 1000

        property int playbackSpeedIndex: playbackSpeedNormalIndex
        property int orientationValueIndex: 0
        property int autoSeekInterval: seekInterval_Small
        property int autoSeekDirection: 1

        property bool isSeeking: false
        property real timeSeekStart
        property real timeSeekEnd

        onIsSeekingChanged: {
            if (isSeeking === true) {
                timeSeekEnd = 0
                timeSeekStart = Date.now()
                console.log("Seek starts: " + timeSeekStart)
            } else {
                timeSeekEnd = Date.now()
                console.log("Seek took: " + (timeSeekEnd - timeSeekStart))
            }
        }

        anchors.fill: rectAreaContents
        anchors.margins: 10
        flushMode: VideoOutput.FirstFrame
        notifyInterval: 10

        onOrientationValueIndexChanged: {
            if (orientationValueIndex >= orientationValues.length) {
                orientationValueIndex = 0
                return
            }

            if (orientationValueIndex < 0) {
                orientationValueIndex = orientationValues.length - 1
                return
            }

            videoController.orientation = orientationValues[orientationValueIndex]
        }

        onPlaybackSpeedIndexChanged: {
            console.log("Playback speed index is now: " + playbackSpeedIndex)

            var playbackSpeed = playbackSpeeds[playbackSpeedIndex]

            videoController.playbackRate = playbackSpeed
        }

        onPlaybackRateChanged: {
            console.log("Playback rate is now: " + playbackRate)
        }

        onPlaying: {
            videoController.muted = compAudioVideoPlayer.userMuted
            videoController.flushMode = VideoOutput.LastFrame
            audioVideoController.ePlaybackStateCurrent = AudioVideoController.EPlaybackState_Playing
        }

        onPaused: {
            audioVideoController.ePlaybackStateCurrent = AudioVideoController.EPlaybackState_Paused
        }

        onStopped: {
            audioVideoController.ePlaybackStateCurrent = AudioVideoController.EPlaybackState_Stopped
        }

        onPositionChanged: {
            //console.log("Position now: " + position)
            if (videoController.isSeeking === true && (videoController.hasVideo)
                    && (Date.now() - timeSeekStart) > 100) {
                videoController.isSeeking = false
            } else if (videoController.isSeeking === true
                       && !videoController.hasVideo) {
                videoController.isSeeking = false
            }

            audioVideoController.iPosition = position
        }

        onSourceChanged: {
            audioVideoController.sSource = source
        }

        onDurationChanged: {
            audioVideoController.iDuration = duration
        }

        onMetaDataChanged: {
            console.log('MEta Data is now:' + metaData)
        }

        onStatusChanged: {
            console.log("Status is now: " + status)
        }

        onBufferProgressChanged: {
            console.log("Buffer progress: " + bufferProgress)
        }

        function onRotateRightPressed() {
            orientationValueIndex += 1
        }

        function onRotateLeftPressed() {
            orientationValueIndex -= 1
        }

        function playPressed() {

            if (audioVideoController.dProgressPercent >= 1.0) {
                videoController.seek(-duration)
                videoController.play()
                return
            }

            if (audioVideoController.ePlaybackStateCurrent
                    != AudioVideoController.EPlaybackState_Playing) {
                videoController.play()
            } else {
                videoController.pause()
            }
        }

        function onRewind() {
            if (videoController.hasVideo)
                videoController.pause()

            if (videoController.seekInterval_Small > videoController.position)
                videoController.seek(0)
            else {
                videoController.seek(
                            videoController.position - videoController.seekInterval_Small)
            }
            videoController.isSeeking = true
        }

        function onFastForward() {

            if (videoController.hasVideo)
                videoController.pause()

            var durationLeft = videoController.duration - videoController.position

            if (videoController.seekInterval_Small > durationLeft)
                videoController.seek(durationLeft)
            else {
                videoController.seek(
                            videoController.position + videoController.seekInterval_Small)
            }
            videoController.isSeeking = true
        }

        function onJumpBackward() {
            if (videoController.hasVideo)
                videoController.pause()

            if (videoController.seekInterval_Large > videoController.position)
                videoController.seek(0)
            else {
                videoController.seek(
                            videoController.position - videoController.seekInterval_Large)
            }
            videoController.isSeeking = true
        }

        function onJumpforward() {
            if (videoController.hasVideo)
                videoController.pause()
            var durationLeft = videoController.duration - videoController.position

            if (videoController.seekInterval_Large > durationLeft)
                videoController.seek(durationLeft)
            else {
                videoController.seek(
                            videoController.position + videoController.seekInterval_Large)
            }
            videoController.isSeeking = true
        }

        Connections {
            target: compAudioVideoPlayer

            function onUserMutedChanged() {
                videoController.muted = compAudioVideoPlayer.userMuted
            }
        }

        Timer {
            id: tmrAutoSeek

            interval: videoController.notifyInterval

            repeat: false

            onTriggered: {
                if (videoController.autoSeekDirection === 0)
                    return
                videoController.muted = true
                videoController.flushMode = VideoOutput.LastFrame

                if (videoController.position < videoController.autoSeekInterval) {
                    console.log("Position too small; Going to start")
                    videoController.seek(-videoController.position)
                    return
                }

                var durationLeft = videoController.duration - videoController.position
                if (durationLeft < videoController.autoSeekInterval) {
                    console.log("Position too great; Going to end")
                    videoController.seek(durationLeft)
                    return
                }

                var seekAmt = videoController.position
                        + (videoController.autoSeekDirection * videoController.autoSeekInterval)
                console.log("Seeking to: " + seekAmt)
                videoController.play()
                videoController.seek(seekAmt)

                tmrWaitForFrame.start()
            }
        }

        Timer {
            id: tmrWaitForFrame

            interval: 500
            repeat: false
            onTriggered: {
                if (videoController.autoSeekDirection === 0)
                    return

                videoController.pause()
                tmrAutoSeek.start()
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                videoController.playPressed()
            }
        }
    }

    CompIconBtn {
        id: btnClose

        anchors {
            top: rectAreaFileInfo.top
            topMargin: 10
            right: rectAreaFileInfo.right
            rightMargin: 10
        }

        height: 40

        iconUrl: compAudioVideoPlayer.imagePath_Close
        iconColor: compAudioVideoPlayer.colorControlIdle

        onClicked: {
            compAudioVideoPlayer.onClosePressed()
        }
    }

    CompLabel {
        id: lblFileInfo

        anchors.centerIn: rectAreaFileInfo

        text: audioVideoController.strAudioVideoFileInfo.sTitle
    }

    CompLabel {
        id: lblPlaybackInfo

        anchors {
            left: rowControls_Playback.right
            right: btnMenu.left

            verticalCenter: btnMenu.verticalCenter
        }

        text: audioVideoController.sFormattedPositionTime + " / "
              + audioVideoController.sFormattedLength
        color: compAudioVideoPlayer.colorPlaybackPosInfo

        horizontalAlignment: Text.AlignHCenter
    }

    Row {
        id: rowControls_Volume

        spacing: 30
        anchors {
            left: rectAreaControls.left
            leftMargin: 20
            verticalCenter: rectAreaControls.verticalCenter
        }

        Slider {
            id: sliderVolume

            property real valuePriorToMute: 1.0
            property bool blockSignals: false

            from: 0.0
            to: 1.0

            height: 60
            width: 200

            Component.onCompleted: {
                sliderVolume.value = videoController.volume
            }

            onValueChanged: {

                if (sliderVolume.blockSignals)
                    return

                if (compAudioVideoPlayer.userMuted) {
                    compAudioVideoPlayer.userMuted = false
                }

                videoController.volume = value
            }

            Connections {
                target: compAudioVideoPlayer

                function onUserMutedChanged() {

                    if (compAudioVideoPlayer.userMuted) {
                        sliderVolume.valuePriorToMute = sliderVolume.value
                        sliderVolume.blockSignals = true
                        sliderVolume.value = 0
                        sliderVolume.blockSignals = false
                    } else {
                        sliderVolume.value = sliderVolume.valuePriorToMute
                    }
                }
            }
        }

        CompIconBtn {
            id: btnMute

            readonly property bool isMuted: compAudioVideoPlayer.userMuted

            height: compAudioVideoPlayer.controlBtnHeight_Small
            width: height
            iconColor: isMuted ? compAudioVideoPlayer.colorControlActive : compAudioVideoPlayer.colorControlIdle
            iconUrl: isMuted ? compAudioVideoPlayer.imagePath_Muted : compAudioVideoPlayer.imagePath_Unmuted
            anchors.verticalCenter: sliderVolume.verticalCenter

            onClicked: {
                if (btnMute.isMuted) {
                    compAudioVideoPlayer.userMuted = false
                } else {
                    compAudioVideoPlayer.userMuted = true
                }
            }
        }
    }

    CompProgressBar {
        id: progressPlaybackBar

        anchors {
            left: rectAreaControls.left
            leftMargin: 20
            right: rectAreaControls.right
            rightMargin: 20
            top: rectAreaControls.top
        }

        height: 4
        percentComplete: audioVideoController.dProgressPercent
        showPercentComplete: false
    }

    CompIconBtn {
        id: btnMenu

        iconUrl: compAudioVideoPlayer.imagePath_Menu
        iconColor: compAudioVideoPlayer.colorControlIdle
        height: compAudioVideoPlayer.controlBtnHeight_Small
        width: height

        anchors {
            right: rectAreaControls.right
            rightMargin: 20
            verticalCenter: rowControls_Playback.verticalCenter
        }

        onClicked: {
            popupMenu.isOpen = !popupMenu.isOpen
        }
    }

    CompPopupBG {
        id: popupMenu

        property bool isOpen: false

        height: colPopupMenuContents.childrenRect.height
                + (colPopupMenuContents.anchors.margins * 2)
        width: colPopupMenuContents.width + (colPopupMenuContents.anchors.margins * 2)
        anchors {
            fill: undefined
            right: btnMenu.right
            bottom: btnMenu.top
            bottomMargin: 10
        }

        transform: Translate {

            y: popupMenu.isOpen ? 0 : (popupMenu.height + popupMenu.anchors.bottomMargin
                                       + (btnMenu.height * 2))

            Behavior on y {
                NumberAnimation {
                    duration: 200
                }
            }
        }

        Column {
            id: colPopupMenuContents

            spacing: 10
            anchors {
                top: parent.top
                left: parent.left
                margins: 10
            }

            Switch {
                id: toggleRepeat

                text: "Repeat"
                height: 40

                checked: false
                onCheckedChanged: {
                    videoController.loops = checked ? MediaPlayer.Infinite : 0
                    popupMenu.isOpen = false
                }

                contentItem: CompLabel {
                    text: parent.text
                    opacity: enabled ? 1.0 : 0.3
                    color: "#ffffff"
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: parent.indicator.width + parent.spacing
                }
            }

            CompLabel {
                text: "SPEED"

                color: "#80ffffff"
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Repeater {
                id: rptPlaybackSpeeds

                model: videoController.playbackSpeeds
                delegate: RadioButton {

                    text: "x" + videoController.playbackSpeeds[index]

                    checked: videoController.playbackSpeedIndex === index

                    height: 40
                    onCheckedChanged: {
                        videoController.playbackSpeedIndex = index
                        popupMenu.isOpen = false
                    }

                    contentItem: CompLabel {
                        text: parent.text
                        opacity: enabled ? 1.0 : 0.3
                        color: "#ffffff"
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: parent.indicator.width + parent.spacing
                    }
                }
            }

            CompLabel {
                visible: videoController.hasVideo
                text: "ORIENTATION"

                color: "#80ffffff"
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                id: roControls_Orientation

                visible: videoController.hasVideo
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 30

                CompIconBtn {
                    id: btnRotateLeft

                    height: compAudioVideoPlayer.controlBtnHeight_Small
                    width: height
                    iconColor: compAudioVideoPlayer.colorControlIdle
                    iconUrl: compAudioVideoPlayer.imagePath_RotateLeft
                    onClicked: videoController.onRotateLeftPressed()

                    anchors.verticalCenter: parent.verticalCenter
                }

                CompIconBtn {
                    id: btnRotateRight

                    height: compAudioVideoPlayer.controlBtnHeight_Small
                    width: height
                    iconColor: compAudioVideoPlayer.colorControlIdle
                    iconUrl: compAudioVideoPlayer.imagePath_RotateRight
                    onClicked: videoController.onRotateRightPressed()

                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    Row {
        id: rowControls_Playback

        //enabled: audioVideoController.bValidFileLoaded
        anchors.centerIn: rectAreaControls
        spacing: 30
        CompIconBtn {
            id: btnJumpBack

            property bool isActive: false

            height: compAudioVideoPlayer.controlBtnHeight_Small
            width: height
            iconColor: isActive ? compAudioVideoPlayer.colorControlActive : compAudioVideoPlayer.colorControlIdle
            iconUrl: compAudioVideoPlayer.imagePath_JumpBack
            onClicked: videoController.onJumpBackward()

            anchors.verticalCenter: parent.verticalCenter
        }

        CompIconBtn {
            id: btnRewind

            property bool isActive: false

            height: compAudioVideoPlayer.controlBtnHeight_Small
            width: height
            iconColor: isActive ? compAudioVideoPlayer.colorControlActive : compAudioVideoPlayer.colorControlIdle
            iconUrl: compAudioVideoPlayer.imagePath_Rewind

            onClicked: {
                videoController.onRewind()
            }

            anchors.verticalCenter: parent.verticalCenter
        }

        CompIconBtn {
            id: btnPlay

            height: compAudioVideoPlayer.controlBtnHeight
            width: height
            iconColor: compAudioVideoPlayer.colorControlIdle
            iconUrl: {
                if (audioVideoController.ePlaybackStateCurrent
                        === AudioVideoController.EPlaybackState_Playing) {
                    return compAudioVideoPlayer.imagePath_Pause
                } else {
                    return compAudioVideoPlayer.imagePath_Play
                }
            }
            onClicked: videoController.playPressed()
        }

        CompIconBtn {
            id: btnFastForward

            property bool isActive: false

            height: compAudioVideoPlayer.controlBtnHeight_Small
            width: height
            iconColor: isActive ? compAudioVideoPlayer.colorControlActive : compAudioVideoPlayer.colorControlIdle
            iconUrl: compAudioVideoPlayer.imagePath_FastForward

            onClicked: videoController.onFastForward()

            anchors.verticalCenter: parent.verticalCenter
        }

        CompIconBtn {
            id: btnJumpForward

            property bool isActive: false

            height: compAudioVideoPlayer.controlBtnHeight_Small
            width: height
            iconColor: isActive ? compAudioVideoPlayer.colorControlActive : compAudioVideoPlayer.colorControlIdle
            iconUrl: compAudioVideoPlayer.imagePath_JumpForward

            onClicked: videoController.onJumpforward()

            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
