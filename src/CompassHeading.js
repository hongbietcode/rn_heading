import {NativeModules, NativeEventEmitter} from 'react-native';

const {CompassHeadingModule} = NativeModules;

let listener;
let _start = CompassHeadingModule.start;
let _stop = CompassHeadingModule.stop;

CompassHeadingModule.start = async (update_rate, callback) => {
  if (listener) await _stop();

  const compassEventEmitter = new NativeEventEmitter(CompassHeadingModule);
  listener = compassEventEmitter.addListener('HeadingUpdated', callback);

  return await _start(update_rate === null ? 0 : update_rate);
};

CompassHeadingModule.stop = async () => {
  listener && listener.remove();
  listener = null;
  await _stop();
};

export default CompassHeadingModule;
