import QtQuick 2.15
import Singletons 1.0

Item {
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
