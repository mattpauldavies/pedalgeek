import Toybox.Activity;
import Toybox.Test;
import Toybox.Time;

class MockActivityInfoNullElapsedTime extends Activity.Info {
  var elapsedTime = null;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function nullElapsedTime(logger) {
    logger.debug("If current lap time is zero return Unknown");
    var view = new TimeToNextView();
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
    var view = new TimeToNextView();
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
    logger.debug("Returns time to next without lap");
    var view = new TimeToNextView();
    var info = new MockActivityInfoWithoutLap();
    var value = view.compute(info);
    Test.assertEqual(value.value(), new Time.Duration(12000).value());
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
    logger.debug("Returns time to distance without lap");
    var view = new TimeToNextView();
    var info = new MockActivityInfoDistanceWithoutLap();
    var value = view.compute(info);
    Test.assertEqual(value.value(), new Time.Duration(6000).value());
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

class MockTimeToNextView extends TimeToNextView {
  function initialize() {
    TimeToNextView.initialize();
    lapStartDistance = 250.toFloat();
    lapStartTime = 50000;
  }
}

(:test)
function distanceWithLap(logger) {
    logger.debug("Returns time to distance with lap");
    var view = new MockTimeToNextView();
    var info = new MockActivityInfoWithLap();
    var value = view.compute(info);
    Test.assertEqual(value.value(), new Time.Duration(4000).value());
    return true;
}

