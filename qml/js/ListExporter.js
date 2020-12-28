// exportList is a semi-general solution for creating vlc-compatible xml-files using only qml + js
// it's made by the man under the pseudonym jollailija and is dual licenced under the WTFPL/public domain
// I'm giving it away in the hopes that people implement it in their apps as no one on harbour currently does

function exportList(list, filename, format) {
    var xmlurl = filename
    var xmlstr = ""

    // SailWave: make sure list is loaded
    stations.load(false)

    switch (format) {
    case "vlc":
        //xmlurl += ".xspf"

        var xmlHeader = '<?xml version="1.0" encoding="UTF-8"?>\n<playlist xmlns="http://xspf.org/ns/0/" xmlns:vlc="http://www.videolan.org/vlc/playlist/ns/0/" version="1">\n    <title>Nettiradiot</title>\n    <trackList>\n'
        var xmlFooter = '</playlist>'

        xmlstr += xmlHeader

        var id = 0

        for (var r = 0; r < list.count; r++) {
            xmlstr += '\t<track>\n'
            xmlstr += '\t\t<location>' + list.get(id).streamUrl + '</location>\n'
            xmlstr += '\t\t<title>' + list.get(id).name + '</title>\n'
            xmlstr += '\t\t<extension application="http://www.videolan.org/vlc/playlist/0">\n'
            xmlstr += '\t\t\t<vlc:id>' + id + '</vlc:id>\n'
            xmlstr += '\t\t</extension>\n'
            xmlstr += '\t</track>\n'
            id++
        }

        xmlstr += '\t</trackList>\n'
        xmlstr += '\t<extension application="http://www.videolan.org/vlc/playlist/0">\n'

        for (var j = 0; j < id; j++) {
            xmlstr += '\t\t<vlc:item tid="' + j + '"/>\n'
        }

        xmlstr += '\t</extension>\n'
        xmlstr += xmlFooter
        break
    default:
        // asemat.xml -style
        //xmlurl += ".xml"
        xmlstr += "<stationlist>\n<!-- SailWave station list export made with exportList.js, implement it in your app! -->\n"
        for (var i = 0; i < list.count; i++) {
            try
            {
                console.debug(i + " Adding " + list.get(i).name + " (url: " + list.get(i).streamUrl + ") to export")
                xmlstr += '\t<item>\n'
                xmlstr += '\t\t<source>' + list.get(i).streamUrl+ '</source>\n'
                xmlstr += '\t\t<title>' + list.get(i).name + '</title>\n'
                //xmlstr += '\t\t<site>' + list.get(i).site + '</site>\n'
                //xmlstr += '\t\t<section>' + list.get(i).section + '</section>\n'
                xmlstr += '\t</item>\n'
            }
            catch (e) {
                console.warn(e)
            }
        }
        xmlstr += '</statiolist>'
    }

    // this is a hack, but it works
    var request = new XMLHttpRequest()
    request.open("PUT", xmlurl, false)
    request.send(xmlstr)
    console.log(list + " exported")
}
