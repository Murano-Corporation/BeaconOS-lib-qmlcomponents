import QtQuick 2.15

Comp__BASE {
    id: compHealthDashboardListItemRoot
    property string paramName: ""

    Component.onCompleted: {
        AssetInfo.signal_EnvImuParamDataChanged.connect(onSignal_EnvImuParamDataChanged)
    }

    function onSignal_EnvImuParamDataChanged( sParamName, paramData) {

        //console.log("Signal got" + paramData);
        if(sParamName !== this.paramName)
            return;

        //console.log("Param " + sParamName + " updated with " + paramData);
    }
}
