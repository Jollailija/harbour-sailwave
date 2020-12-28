import QtQuick 2.0
import QtQuick.XmlListModel 2.0

QtObject {
    function startImport(fileUrl, format) {
        switch (format) {
        case "vlc":
            importModel.query = "/playlist/trackList/track"
            nameRole.query = "title/string()"
            streamUrlRole.query = "location/string()"
            break
        case "asemat.xml":
            importModel.query = "/stationlist/item"
            nameRole.query = "title/string()"
            streamUrlRole.query = "source/string()"
            break
        }
        // I got a
        // [D] unknown:0 - QNetworkReplyImpl::_q_startOperation was called more than once
        // so here's a workaround
        var request = new XMLHttpRequest()
        request.open("GET", fileUrl, false)
        request.send(null)
        importModel.xml = request.responseText
        importModel.reload()
        xmlWaitTimer.start()
    }

    property Timer xmlWaitTimer: Timer {
        property int retrycount: 0
        interval: 3000
        running: false
        repeat: true
        onTriggered: readXml()
    }

    function readXml() {
        if (importModel.status === 1 && importModel.count > 0) {
            xmlWaitTimer.stop()
            for (var i = 0; i < importModel.count; i++) {
                var component = Qt.createComponent("../common/Station.qml") //new Station()
                var s = component.createObject(null, {
                                                   "stationId": -1,
                                                   "name": importModel.get(i).name,
                                                   "streamUrl": importModel.get(i).streamUrl
                                               })

                if (component.status === Component.Ready) {
                    //TODO: validate imported stations
                    stations.addOrUpdateWithStation(s)
                }
            }

        }
        else {
            console.debug("Waiting for xml, status " + importModel.status + " and count " + importModel.count)
            console.debug(importModel.query)
            console.debug(streamUrlRole.query)
            console.debug(nameRole.query)
            xmlWaitTimer.retrycount++
            if (xmlWaitTimer.retrycount > 5) {
                console.warn("reloading")
                xmlWaitTimer.retrycount = 0
                importModel.reload()
            }
        }
    }

    property XmlListModel importModel: XmlListModel {
        XmlRole {
            id: nameRole
            name: "name"
        }
        XmlRole {
            id: streamUrlRole
            name: "streamUrl"
        }
    }

}
