import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class CurrentStopView extends WatchUi.SimpleDataField {

    hidden var lastStoppedAt as Number;

    function initialize() {
        SimpleDataField.initialize();
        label = "STOP";

        self.lastStoppedAt = 0;
    }

    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
        var currentSpeed = info.currentSpeed == null ? 0 : info.currentSpeed;

        if (currentSpeed > 0) {
          self.lastStoppedAt = 0;
          return "Moving";
        }

        var elapsedTime = info.elapsedTime == null ? 0 : info.elapsedTime;

        if (self.lastStoppedAt == 0) {
          self.lastStoppedAt = elapsedTime;
        }

        var currentStop = elapsedTime - self.lastStoppedAt;

        if (currentStop < 0) {
          return new Time.Duration(0);
        }

        var currentStopDuration = new Time.Duration((currentStop / 1000).toNumber());

        return currentStopDuration;
    }

}
