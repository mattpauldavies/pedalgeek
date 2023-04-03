import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class DistanceToNextView extends WatchUi.SimpleDataField {

    function initialize() {
        SimpleDataField.initialize();
        label = "NEXT DISTANCE";
    }

    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
        var distanceToNextPoint = info.distanceToNextPoint;
        
        if (distanceToNextPoint == null) {
          distanceToNextPoint = info.distanceToDestination == null ? 0 : info.distanceToDestination;
        }
        
        if (distanceToNextPoint < 1000) {
          return distanceToNextPoint.format("%d") + " m";
        }

        var distanceToNextPointInKm = distanceToNextPoint.toFloat() / 1000;
        return distanceToNextPointInKm.format("%.2f") + " km";
    }

}
