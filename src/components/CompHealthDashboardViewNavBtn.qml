import QtQuick 2.12

CompImageIcon {
    id: compHealthDashboardViewNavBtnRoot

    property alias alertCount: indicatorAlertCount.alertCount
    property string tabName: ''


    signal clicked()

    source: "file:///usr/share/BeaconOS-lib-images/images/AlertFill.svg"
    color: "White"
    opacity: enabled ? 1.0 : 0.3
    MouseArea{

        onClicked: compHealthDashboardViewNavBtnRoot.clicked()

        anchors{
            fill: parent
        }
    }

    CompIndicatorAlertCount {
        id: indicatorAlertCount

        alertCount: compHealthDashboardContentRoot.alertCount
    }
}
