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
    var view = new ArrivalAtNextView();
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
    var view = new ArrivalAtNextView();
    var info = new MockActivityInfoZeroElapsedTime();
    var value = view.compute(info);
    Test.assertEqual(value, "Unknown");
    return true;
}

class MockActivityInfoWithoutLap extends Activity.Info {
  var elapsedTime = 60000;
  var elapsedDistance = 500;
  var distanceToNextPoint = 100000;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function withoutLap(logger) {
    logger.debug("Returns ETA without lap");
    var view = new ArrivalAtNextView();
    var info = new MockActivityInfoWithoutLap();
    var value = view.compute(info);
    var timeToNext = new Time.Duration(12000);
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

class MockActivityInfoDistanceWithoutLap extends Activity.Info {
  var elapsedTime = 60000;
  var elapsedDistance = 500;
  var distanceToDestination = 50000;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function distanceWithoutLap(logger) {
    logger.debug("Returns ETA to distance without lap");
    var view = new ArrivalAtNextView();
    var info = new MockActivityInfoDistanceWithoutLap();
    var value = view.compute(info);
    var timeToNext = new Time.Duration(6000);
    var eta = Gregorian.info(Time.now().add(timeToNext), Time.FORMAT_SHORT);
    logger.debug(value);
    logger.debug(Lang.format(
        "$1$:$2$",
        [
            eta.hour.format("%d"),
            eta.min.format("%02d"),
        ]
    ));
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
  var distanceToNextPoint = 100000;

  function initialize() {
    Activity.Info.initialize();
  }
}

class MockArrivalAtNextView extends ArrivalAtNextView {
  function initialize() {
    ArrivalAtNextView.initialize();
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
    var view = new MockArrivalAtNextView();
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
