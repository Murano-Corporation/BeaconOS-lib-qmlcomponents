import QtQuick 2.15
import QtQuick.Controls 2.12
import CONSTANTS 1.0

Item {
    id: compRaptorRadialPopoutMenu

    /*
    0 = TOP LEFT
    1 = TOP CENTER
    2 = TOP RIGHT
    3 = CENTER RIGHT
    4 = BOTTOM RIGHT
    5 = BOTTOM CENTER
    6 = BOTTOM LEFT
    7 = CENTER LEFT
    */
    property int orientation: 0

    property alias repeater: repeaterMain
    property alias delegate: repeaterMain.delegate

    property alias button: btnContext2
    readonly property bool rightAnchor:
        compRaptorRadialPopoutMenu.orientation === 2 ||
        compRaptorRadialPopoutMenu.orientation === 3 ||
        compRaptorRadialPopoutMenu.orientation === 4

    readonly property bool bottomAnchor:
        compRaptorRadialPopoutMenu.orientation === 4 ||
        compRaptorRadialPopoutMenu.orientation === 5 ||
        compRaptorRadialPopoutMenu.orientation === 6

    readonly property bool leftAnchor:
        compRaptorRadialPopoutMenu.orientation === 6 ||
        compRaptorRadialPopoutMenu.orientation === 7 ||
        compRaptorRadialPopoutMenu.orientation === 0

    readonly property bool topAnchor:
        compRaptorRadialPopoutMenu.orientation === 0 ||
        compRaptorRadialPopoutMenu.orientation === 1 ||
        compRaptorRadialPopoutMenu.orientation === 2

    property var model: ListModel{
        ListElement{
            action: function(){ console.log("Action pressed")}
            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Stabilize.svg"
        }
        ListElement{
            action: function(){ console.log("Action pressed")}
            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Stabilize.svg"
        }
        ListElement{
            action: function(){ console.log("Action pressed")}
            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Stabilize.svg"
        }
        ListElement{
            action: function(){ console.log("Action pressed")}
            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Stabilize.svg"
        }
        ListElement{
            action: function(){ console.log("Action pressed")}
            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Stabilize.svg"
        }
    }

    signal signalItemClicked(string action)


    width: button.width
    height: button.height


    function close(){
        compRaptorControlRadialMenu2.isOpen = false
    }

    function open(){
        compRaptorControlRadialMenu2.isOpen = true
        compRaptorControlRadialMenu2.focus = true
    }


    FocusScope {
        id: compRaptorControlRadialMenu2

        property bool isOpen: false

        readonly property int radiusSign: !compRaptorRadialPopoutMenu.topAnchor ? 1.0 : -1.0
        readonly property int angleSign: !compRaptorRadialPopoutMenu.leftAnchor ? -1.0 : 1.0

        height: 300
        width: 300
        anchors{
            bottom: btnContext2.bottom
            bottomMargin: btnContext2.height * 0.5
            left: btnContext2.right
            leftMargin: -btnContext2.width * 0.5
        }

        //Rectangle{
        //
        //    anchors.fill: parent
        //    color: "transparent"
        //
        //
        //}

        opacity: 0.0

        onFocusChanged: {
            if(!focus)
            {
            close()
            }
        }


        onIsOpenChanged: {
            if( isOpen === true )
            {
                opacity = 1.0
                repeaterMain.radiusScaleFactor = 1.0
                repeaterMain.angleMod = 0.5
            } else {
                opacity = 0.0
                repeaterMain.radiusScaleFactor = 0.0
                repeaterMain.angleMod = 0.0
            }
        }

        function openToggle()
        {
            isOpen = !isOpen
            if(isOpen)
                compRaptorControlRadialMenu2.focus = true
        }

        Behavior on opacity{
            NumberAnimation{
                duration: 250
            }
        }

        Repeater{
            id: repeaterMain

            property real radiusScaleFactor: 0.0
            property int radius: Math.min(width, height) * radiusScaleFactor * compRaptorControlRadialMenu2.radiusSign
            property int iconWidth: 90  // Adjust icon width based on the ListView size and delegate count
            property int iconHeight: 90  // Adjust icon height similarly

            property real angleMod: 0.0
            readonly property real arcAngle: Math.PI * angleMod

            anchors.fill: parent
            model: compRaptorRadialPopoutMenu.model

            Behavior on angleMod{
                NumberAnimation{
                    duration: 250
                }
            }

            Behavior on radiusScaleFactor{
                NumberAnimation{
                    duration: 250
                }
            }


            delegate: Item {

                width: repeaterMain.iconWidth
                height: repeaterMain.iconHeight

                transform: Translate {
                    property real angle: repeaterMain.arcAngle * (index / (repeaterMain.count - 1)) * compRaptorControlRadialMenu2.angleSign

                    x: (repeaterMain.radius * Math.sin(angle) - (width * 0.5))
                    y: (repeaterMain.height - height) - (repeaterMain.radius * (Math.cos(angle)) - (height * 0.5))
                }

                ToolTip{
                    id: tooltip
                    text: model.tooltip_text ? model.tooltip_text : ""
                }

                Loader{
                    id: ldrDefaultDelegate

                    active:  model.type === 'default'
                    anchors.fill: parent

                    sourceComponent: CompRaptorNavMenuItem{
                        enabled: model.is_enabled()
                        imgIconSrc: model.imgIconSrc
                        opacity: model.is_enabled() ? 1.0 : 0.3

                        onClicked: {
                            compRaptorRadialPopoutMenu.close()
                            model.action()
                        }

                        onLongPressed: {
                            tooltip.open()
                        }
                    }
                }

                Loader{
                    id: ldrDroneStateDelegate

                    active: model.type === 'drone_state'
                    anchors.fill: parent

                    sourceComponent: CompRaptorNavMenuItem{

                        imgIconColor: model.is_active() ? "Green" : "White"
                        enabled: model.is_enabled()
                        imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/DroneFront.svg"
                        opacity: model.is_enabled() ? 1.0 : 0.3

                        imageIcon{


                            anchors{
                                fill: undefined
                                top: imageIcon.parent.top
                                left: imageIcon.parent.left
                                right: imageIcon.parent.right
                            }

                            height: lblDroneState.height
                        }

                        onClicked: {
                            compRaptorRadialPopoutMenu.close()
                            model.action()
                        }

                        onLongPressed: {
                            tooltip.open()
                        }

                        CompLabel{
                            id: lblDroneState

                            text: model.drone_state

                            anchors{
                                fill: undefined
                                bottom: parent.bottom
                                left: parent.left
                                right: parent.right
                            }
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            height: parent.height * 0.5

                            font{
                                pixelSize: 16
                                capitalization: Font.AllUppercase

                            }
                        }


                    }
                }

                Loader{
                    id: ldrPursuitStateDelegate

                    active: model.type === 'pursuit_state'
                    anchors.fill: parent

                    sourceComponent: CompRaptorNavMenuItem{
                        enabled: model.is_enabled()
                        imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Target.svg"
                        imgIconColor: model.is_active() ? "Purple" : "White"
                        opacity: model.is_enabled() ? 1.0 : 0.3

                        imageIcon{


                            anchors{
                                fill: undefined
                                top: imageIcon.parent.top
                                left: imageIcon.parent.left
                                right: imageIcon.parent.right
                            }

                            height: lblPursuitState.height
                        }

                        onClicked: {
                            compRaptorRadialPopoutMenu.close()
                            model.action()
                        }

                        onLongPressed: {
                            tooltip.open()
                        }

                        CompLabel{
                            id: lblPursuitState

                            text: model.pursuit_state

                            anchors{
                                bottom: parent.bottom
                                left: parent.left
                                right: parent.right
                            }
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            height: parent.height * 0.5

                            font{
                                pixelSize: 16
                                capitalization: Font.AllUppercase

                            }
                        }
                    }
                }

                MouseArea{
                    id: mousearea_Tooltip

                    enabled: !model.is_enabled()
                    anchors.fill: parent
                    onPressAndHold: tooltip.open()
                }
            }
        }
    }

    CompRaptorNavMenuItem {
        id: btnContext2

        anchors{
            right: compRaptorRadialPopoutMenu.rightAnchor ? parent.right : undefined
            bottom: compRaptorRadialPopoutMenu.bottomAnchor ? parent.bottom : undefined
            left: compRaptorRadialPopoutMenu.leftAnchor ? parent.left : undefined
            top: compRaptorRadialPopoutMenu.topAnchor ? parent.top : undefined
        }

        onClicked: {
            compRaptorControlRadialMenu2.openToggle()
        }

    }


}
