import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class MovingPercentageView extends WatchUi.SimpleDataField {

    hidden var lastStoppedAt as Number;
    hidden var previouslyComputedStop as Number;
    hidden var totalStopped as Number;

    function initialize() {
        SimpleDataField.initialize();
        label = "MOVING %";

        self.lastStoppedAt = 0;
        self.totalStopped = 0;
        self.previouslyComputedStop = 0;
    }

    function calculateMovingPercentage(elapsedTime as Numeric) as String {
        if (elapsedTime == 0) {
          return "0%";
        }

        var movingPercentage = 1.toFloat() - (self.totalStopped.toFloat() / elapsedTime.toFloat());

        if (movingPercentage < 0) {
          return "0%";
        }

        return (movingPercentage * 100).toNumber().format("%d") + "%";
    }

    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
        var elapsedTime = info.elapsedTime == null ? 0 : info.elapsedTime;
        if (elapsedTime == 0) {
          // reset total stopped when timer starts
          self.totalStopped = 0;
        }

        var currentSpeed = info.currentSpeed == null ? 0 : info.currentSpeed;

        if (currentSpeed > 0) {
          self.lastStoppedAt = 0;
          self.previouslyComputedStop = 0;
          return self.calculateMovingPercentage(elapsedTime);
        }

        if (self.lastStoppedAt == 0) {
          self.lastStoppedAt = elapsedTime;
        }

        var currentStop = elapsedTime - self.lastStoppedAt;

        // only add the incremental stops to prevent exponential growth
        var stopIncrement = currentStop - self.previouslyComputedStop;
        self.totalStopped += stopIncrement;
        self.previouslyComputedStop = currentStop;

        return self.calculateMovingPercentage(elapsedTime);
    }

}
