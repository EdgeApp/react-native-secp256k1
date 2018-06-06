
# react-native-secp256k1

*This project is deprecated*. Please see [react-native-fast-crypto](https://github.com/Airbitz/react-native-fast-crypto), which includes secp256k1 routines.

## Getting started

`$ npm install react-native-secp256k1 --save`

### Mostly automatic installation

`$ react-native link react-native-secp256k1`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-secp256k1` and add `RNMyFancyLibrary.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNMyFancyLibrary.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNMyFancyLibraryPackage;` to the imports at the top of the file
  - Add `new RNMyFancyLibraryPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-secp256k1'
  	project(':react-native-secp256k1').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-secp256k1/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-secp256k1')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNMyFancyLibrary.sln` in `node_modules/react-native-secp256k1/windows/RNMyFancyLibrary.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Com.Reactlibrary.RNMyFancyLibrary;` to the usings at the top of the file
  - Add `new RNMyFancyLibraryPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNMyFancyLibrary from 'react-native-secp256k1';

// TODO: What to do with the module?
RNMyFancyLibrary;
```
  
