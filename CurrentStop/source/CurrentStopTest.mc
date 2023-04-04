import Toybox.Activity;
import Toybox.Test;
import Toybox.Time;

class MockActivityInfoMoving extends Activity.Info {
  var currentSpeed = 2;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function returnMoving(logger) {
    logger.debug("Return moving if speed greater than zero");
    var view = new CurrentStopView();
    var info = new MockActivityInfoMoving();
    var value = view.compute(info);
    Test.assertEqual(value, "Moving");
    return true;
}

class MockActivityInfoStopped extends Activity.Info {
  var currentSpeed = 0;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function returnStoppedTime(logger) {
    logger.debug("Return stopped time if speed equals zero");
    var view = new CurrentStopView();
    var info = new MockActivityInfoStopped();
    var value = view.compute(info);
    Test.assertEqual(value.value(), new Time.Duration(0).value());
    return true;
}

class MockActivityInfoFirstStop extends Activity.Info {
  var currentSpeed = 0;
  var elapsedTime = 5000;

  function initialize() {
    Activity.Info.initialize();
  }
}

class MockActivityInfoSecondStop extends Activity.Info {
  var currentSpeed = 0;
  var elapsedTime = 8000;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function returnStoppedTimeAfterPause(logger) {
    logger.debug("Return stopped time after a longer stop");
    var view = new CurrentStopView();
    var firstStopInfo = new MockActivityInfoFirstStop();
    view.compute(firstStopInfo);
    var secondStopInfo = new MockActivityInfoSecondStop();
    var value = view.compute(secondStopInfo);
    Test.assertEqual(value.value(), new Time.Duration(3).value());
    return true;
}

class MockActivityInfoEndOfActivity extends Activity.Info {
  var currentSpeed = 0;
  var elapsedTime = 0;

  function initialize() {
    Activity.Info.initialize();
  }
}

class MockCurrentStopView extends CurrentStopView {
  function initialize() {
    CurrentStopView.initialize();
    lastStoppedAt = 500;
  }
}

(:test)
function returnZeroIfElapsedTimeIsZero(logger) {
    logger.debug("Return stopped time after a longer stop");
    var view = new CurrentStopView();
    var info = new MockActivityInfoEndOfActivity();
    var value = view.compute(info);
    Test.assertEqual(value.value(), new Time.Duration(0).value());
    return true;
}
