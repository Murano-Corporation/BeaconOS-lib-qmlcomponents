import QtQuick 2.0

Rectangle{
    id: compBeaconOsInduct_InspectInfoPanel


    color: "#CDDBE1"

    Item{
        id: groupTopControls
        height: 36
        anchors{
            top: parent.top
            margins: 40
            left: parent.left
            right: parent.right

        }

        CompLabel{
            id: zoneName

            text: "Door 22 (1 of 2)"
            color: "black"

            font.pixelSize: groupTopControls.height * 0.85
            verticalAlignment: Text.AlignVCenter
        }

        CompIconBtn{
            id: btnNextPage

            anchors{
                left: zoneName.right
                leftMargin: 40
                verticalCenter: zoneName.verticalCenter
            }

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/RightFill.svg"

            height: zoneName.height * 0.85
        }

    }

    Column{
        id: columnContents

        anchors{
            top: groupTopControls.bottom
            topMargin: 70
            left: groupTopControls.left
            right: groupTopControls.right
            bottom: parent.bottom
            bottomMargin: 100
        }

        spacing: 35

        Column{
            width: columnContents.width

            CompLabel{
                id: lblZone

                text: "Zone:"
                font.weight: Font.Bold
                color: "black"
                font.pixelSize: 30
            }

            CompLabel{
                id: lblZone_Value

                text: "18.10: Center Fuselage, Upper Right - Internal"
                font.weight: Font.Light
                color: "black"
                font.pixelSize: 30
            }
        }

        Column{
            width: columnContents.width

            CompLabel{
                id: lblWorkUnitCode

                text: "Work Unit Code:"
                font.weight: Font.Bold
                color: "black"
                font.pixelSize: 30
            }

            CompLabel{
                id: lblWorkUnitCode_Value

                text: "11B10, 11B52, 11B1S, 11B24, 11B35, 11B3F"
                font.weight: Font.Light
                color: "black"
                font.pixelSize: 30
            }
        }

        Column{
            width: columnContents.width

            CompLabel{
                id: lblPartNumbers

                text: "Work Unit Code:"
                font.weight: Font.Bold
                color: "black"
                font.pixelSize: 30
            }

            CompLabel{
                id: lblPartNumbers_Value

                text: "74A325034, 74A326101, 74A326108, 74A326110, 74A326128, 74A326130, 74A326306, 74A326309"
                font.weight: Font.Light
                color: "black"
                font.pixelSize: 30

                width: parent.width

                wrapMode: Text.WordWrap
            }
        }

        Grid{
            width: columnContents.width

            columns: 3

            CompLabel{
                id: lblFMDC
                width: parent.width * 0.33333
                text: "FMDC:"
                font.weight: Font.Bold
                color: "black"
                font.pixelSize: 30
            }

            CompLabel{
                id: lblRQMT
                width: parent.width * 0.33333
                text: "RQMT NO.:"
                font.weight: Font.Bold
                color: "black"
                font.pixelSize: 30
            }

            CompLabel{
                id: lblEFF
                width: parent.width * 0.33333
                text: "EFF:"
                font.weight: Font.Bold
                color: "black"
                font.pixelSize: 30
            }

            CompLabel{
                id: lblFMDC_Value

                text: "1B4MG"
                font.weight: Font.Light
                color: "black"
                font.pixelSize: 30
            }

            CompLabel{
                id: lblRQMT_Value

                text: "CF.022.R.SF.COR"
                font.weight: Font.Light
                color: "black"
                font.pixelSize: 30
            }

            CompLabel{
                id: lblEFF_Value

                text: "E/F/G"
                font.weight: Font.Light
                color: "black"
                font.pixelSize: 30
            }
        }
    }

}
