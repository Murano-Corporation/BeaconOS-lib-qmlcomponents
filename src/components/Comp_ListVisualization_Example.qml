import QtQuick 2.0

Item {

    height: 1080
    width: 1920


    GridView{
        anchors.fill: parent

        cellHeight: 200
        cellWidth: 200

        model: ListModel{

            ListElement{
                name: "Altitude (m)"
                value: "0.00"
            }


            ListElement{
                name: "Groundspeed (m/s)"
                value: "1.11"
            }

            ListElement{
                        name: "Dist to WP (m)"
                        value: "2.22"
                    }

        }


        delegate: Comp_TEST_Jesse{
            height: 200
            width: 200


            textName: model.name
            textValue: model.value
        }


    }


}
