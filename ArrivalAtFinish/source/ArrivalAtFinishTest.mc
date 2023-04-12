import Toybox.Activity;
import Toybox.Lang;
import Toybox.Test;
import Toybox.Time;
import Toybox.Time.Gregorian;

class MockActivityInfoNullElapsedTime extends Activity.Info {
  var elapsedTime = null;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function nullElapsedTime(logger) {
    logger.debug("If current lap time is zero return Unknown");
    var view = new ArrivalAtFinishView();
    var info = new MockActivityInfoNullElapsedTime();
    var value = view.compute(info);
    Test.assertEqual(value, "Unknown");
    return true;
}

class MockActivityInfoZeroElapsedTime extends Activity.Info {
  var elapsedTime = 0;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function zeroElapsedTime(logger) {
    logger.debug("If current lap speed is zero return Unknown");
    var view = new ArrivalAtFinishView();
    var info = new MockActivityInfoZeroElapsedTime();
    var value = view.compute(info);
    Test.assertEqual(value, "Unknown");
    return true;
}

class MockActivityInfoWithoutDistance extends Activity.Info {
  var elapsedTime = 60000;
  var elapsedDistance = 500;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function doesNotCrashIfDistanceNotSet(logger) {
    logger.debug("Returns ETA without lap");
    var view = new ArrivalAtFinishView();
    var info = new MockActivityInfoWithoutDistance();
    var value = view.compute(info);
    var timeToNext = new Time.Duration(0);
    var eta = Gregorian.info(Time.now().add(timeToNext), Time.FORMAT_SHORT);
    Test.assertEqual(value, "No Course");
    return true;
}

class MockActivityInfoWithoutLap extends Activity.Info {
  var elapsedTime = 60000;
  var elapsedDistance = 500;
  var distanceToDestination = 100000;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function withoutLap(logger) {
    logger.debug("Returns ETA without lap");
    var view = new ArrivalAtFinishView();
    var info = new MockActivityInfoWithoutLap();
    var value = view.compute(info);
    var timeToNext = new Time.Duration(12000);
    var eta = Gregorian.info(Time.now().add(timeToNext), Time.FORMAT_SHORT);
    Test.assertEqual(value, Lang.format(
        "$1$:$2$",
        [
            (eta.hour - 12).format("%d"),
            eta.min.format("%02d"),
        ]
    ));
    return true;
}

class MockActivityInfoWithLap extends Activity.Info {
  var elapsedTime = 60000;
  var elapsedDistance = 500;
  var distanceToDestination = 100000;

  function initialize() {
    Activity.Info.initialize();
  }
}

class Mock24HourArrivalAtFinishView extends ArrivalAtFinishView {
  function initialize() {
    ArrivalAtFinishView.initialize();
    lapStartDistance = 250.toFloat();
    lapStartTime = 50000;
  }

  function is24Hour() {
    return true;
  }
}

(:test)
function distanceWithLap24Hour(logger) {
    logger.debug("Returns ETA to distance with lap in 24 hour format");
    var view = new Mock24HourArrivalAtFinishView();
    var info = new MockActivityInfoWithLap();
    var value = view.compute(info);
    var timeToNext = new Time.Duration(4000);
    var eta = Gregorian.info(Time.now().add(timeToNext), Time.FORMAT_SHORT);
    Test.assertEqual(value, Lang.format(
        "$1$:$2$",
        [
            eta.hour.format("%d"),
            eta.min.format("%02d"),
        ]
    ));
    return true;
}
