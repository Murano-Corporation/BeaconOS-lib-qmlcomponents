import QtQuick 2.0

Item {
    id: subscreenInduct_Start_Root
    anchors.fill: parent

    signal inductAssetClicked()
    signal startInspectClicked()
    signal continueInspectClicked()

    Row{
        id: rowNavButtons
        spacing: 34

        anchors.centerIn: parent

        Repeater{
            id: repeater
            model: [
                {
                    name: "Induct Asset",
                    iconUrl: "file:///usr/share/BeaconOS-lib-images/images/InductFill.svg",
                    onClicked: function(){subscreenInduct_Start_Root.inductAssetClicked()}
                },
                {
                    name: "Start Inspection",
                    iconUrl: "file:///usr/share/BeaconOS-lib-images/images/SearchInspectFill.svg",
                    onClicked: function(){subscreenInduct_Start_Root.startInspectClicked()}
                },
                {
                    name: "Continue Inspection",
                    iconUrl: "file:///usr/share/BeaconOS-lib-images/images/Induct.svg",
                    onClicked: function(){subscreenInduct_Start_Root.continueInspectClicked()}
                }
            ]

            CompRepairScreenNavButton {
                id: compRepairScreenNavButton
                height: 594
                width: 550

                name: modelData.name
                iconPath: modelData.iconUrl
                onNavButtonClicked:{
                    console.log("Clicked caught")
                    //modelData.onClicked
                    startInspectClicked()
                }
            }

        }


    }


}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.33;height:914;width:1800}
}
##^##*/
