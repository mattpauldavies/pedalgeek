import Toybox.Activity;
import Toybox.Test;
import Toybox.Time;

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

class MockActivityInfoMoving extends Activity.Info {
  var currentSpeed = 2;
  var elapsedTime = 9000;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function returnMoving(logger) {
    logger.debug("Return saved total stopped value if moving");
    var view = new TotalStoppedView();
    var firstStopInfo = new MockActivityInfoFirstStop();
    view.compute(firstStopInfo);
    var secondStopInfo = new MockActivityInfoSecondStop();
    view.compute(secondStopInfo);
    var movingInfo = new MockActivityInfoMoving();
    var value = view.compute(movingInfo);
    Test.assertEqual(value.value(), new Duration(3).value());
    return true;
}

class MockActivityInfoThirdStop extends Activity.Info {
  var currentSpeed = 0;
  var elapsedTime = 10000;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function returnIncrementalStop(logger) {
    logger.debug("Return the updated total stop time");
    var view = new TotalStoppedView();
    var firstStopInfo = new MockActivityInfoFirstStop();
    view.compute(firstStopInfo);
    var secondStopInfo = new MockActivityInfoSecondStop();
    view.compute(secondStopInfo);
    var thirdStopInfo = new MockActivityInfoThirdStop();
    var value = view.compute(thirdStopInfo);
    Test.assertEqual(value.value(), new Duration(5).value());
    return true;
}

class MockActivityInfoRestart extends Activity.Info {
  var currentSpeed = 2;
  var elapsedTime = 0;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function resetTotalStop(logger) {
    logger.debug("Reset total stop when elapsed time is zero");
    var view = new TotalStoppedView();
    var firstStopInfo = new MockActivityInfoFirstStop();
    view.compute(firstStopInfo);
    var secondStopInfo = new MockActivityInfoSecondStop();
    view.compute(secondStopInfo);
    var thirdStopInfo = new MockActivityInfoThirdStop();
    view.compute(thirdStopInfo);
    var info = new MockActivityInfoRestart();
    var value = view.compute(info);
    Test.assertEqual(value.value(), new Duration(0).value());
    return true;
}

class MockActivityInfoRestartNull extends Activity.Info {
  var currentSpeed = 2;
  var elapsedTime = null;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function resetTotalStopOnNull(logger) {
    logger.debug("Reset total stop when elapsed time is null");
    var view = new TotalStoppedView();
    var firstStopInfo = new MockActivityInfoFirstStop();
    view.compute(firstStopInfo);
    var secondStopInfo = new MockActivityInfoSecondStop();
    view.compute(secondStopInfo);
    var thirdStopInfo = new MockActivityInfoThirdStop();
    view.compute(thirdStopInfo);
    var info = new MockActivityInfoRestartNull();
    var value = view.compute(info);
    Test.assertEqual(value.value(), new Duration(0).value());
    return true;
}
