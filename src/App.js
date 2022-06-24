import React from 'react';
import {View, Text} from 'react-native';
import CompassHeading from './CompassHeading';

const App = () => {
  React.useEffect(() => {
    const degree_update_rate = 3;

    CompassHeading.start(degree_update_rate, ({heading, accuracy}) => {
      console.log('CompassHeading: ', heading, accuracy);
    });

    return () => {
      CompassHeading.stop();
    };
  }, []);

  return (
    <View>
      <Text>Hello World</Text>
    </View>
  );
};

export default App;
