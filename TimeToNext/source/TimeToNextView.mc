import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class TimeToNextView extends WatchUi.SimpleDataField {

    hidden var lapStartDistance as Float; // in meters
    hidden var lapStartTime as Number; // in milliseconds

    function initialize() {
        SimpleDataField.initialize();
        label = "TIME TO NEXT";

        self.lapStartDistance = 0.toFloat();
        self.lapStartTime = 0;
    }

    function onTimerLap() {
        var info = Activity.getActivityInfo();
        self.lapStartDistance = info.elapsedDistance == null ? 0.toFloat() : info.elapsedDistance;
        self.lapStartTime = info.elapsedTime == null ? 0 : info.elapsedTime;
    }

    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
        var elapsedDistance = info.elapsedDistance == null ? 0.toFloat() : info.elapsedDistance;
        var currentLapDistance = elapsedDistance - self.lapStartDistance;

        var elapsedTime = info.elapsedTime == null ? 0 : info.elapsedTime;
        var currentLapTime = (elapsedTime - self.lapStartTime).toFloat() / 1000; // in seconds

        if (currentLapTime == 0) {
          return "Unknown";
        }

        var lapAvgSpeed = currentLapDistance / currentLapTime; // in meters per second
        var currentSpeed = info.currentSpeed == null ? 0 : info.currentSpeed;
        if (lapAvgSpeed == 0) {
          lapAvgSpeed = currentSpeed;
        }

        if (lapAvgSpeed == 0) {
          return "Unknown";
        }

        var distanceToNextPoint = info.distanceToNextPoint;
        
        if (distanceToNextPoint == null) {
          distanceToNextPoint = info.distanceToDestination == null ? 0 : info.distanceToDestination;
        }

        var timeToNextInSeconds = distanceToNextPoint / lapAvgSpeed;

        var timeToNext = new Time.Duration(timeToNextInSeconds.toNumber());

        return timeToNext;
    }

}
