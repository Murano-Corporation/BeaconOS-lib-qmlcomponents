import QtQuick 2.12

import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0

CompResizableMoveableContainer{
    id: rectContents

    property alias timestamp: lblTimestamp.text
    property alias gpsCoords: lblGps.text
    property var inference: [["a","b"],["c","d"]]

    width: 450
    height: 300

    //radius: 40


    CompPopupBG{}

    Item{
        id: contents

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 20
        }

        CompImageIcon {
            id: iconTime

            anchors{
                top: parent.top
                left: parent.left
            }

            height: 36
            width: 36

            source: "file:///usr/share/BeaconOS-lib-images/images/Clock.svg"
            color: "White"
        }

        CompLabel{
            id: lblTimestamp
            anchors{
                left: iconTime.right
                leftMargin: 21
                verticalCenter: iconTime.verticalCenter
            }

            text: "{timestamp.long}"
            font{
                pixelSize: 30
                weight: Font.Light
            }
        }

        CompImageIcon {
            id: iconGps

            anchors{
                top: iconTime.bottom
                topMargin: 22
                left: iconTime.left
            }

            height: iconTime.height
            width: iconTime.width

            source: "file:///usr/share/BeaconOS-lib-images/images/PinLocation.svg"
            color: "White"
        }

        CompLabel{
            id: lblGps
            anchors{
                left: iconGps.right
                leftMargin: 21
                verticalCenter: iconGps.verticalCenter
            }

            text: "{gpsCoords}"
            font{
                pixelSize: 30
                weight: Font.Light
            }
        }


        ListView{
            id: tableInferences

            property real itemHeight: 40

            anchors{
                top: lblGps.bottom
                topMargin: 40


                left: parent.left
                right: parent.right
            }

            model: rectContents.inference
            height: count * itemHeight
            delegate: Item{

                width: tableInferences.width
                height: tableInferences.itemHeight

                CompLabel{
                    id: lblKey

                    anchors{
                        top: parent.top
                        left: parent.left
                        bottom: parent.bottom
                    }

                    font{
                        pixelSize: 30
                        weight: Font.Light
                    }


                    text: modelData[0] + ": "
                    verticalAlignment: Text.AlignTop
                }

                CompLabel{
                    id: lblValue

                    anchors{
                        top: parent.top
                        right: parent.right
                        bottom: parent.bottom
                        left: lblKey.right
                        leftMargin: 10
                    }

                    font{
                        pixelSize: 30
                        weight: Font.Light
                    }


                    text: modelData[1]
                    horizontalAlignment: Text.AlignRight
                    wrapMode: Text.WordWrap
                }
            }
        }

    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
