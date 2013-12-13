//created using the tutorial located at the Dart code lab at https://www.dartlang.org/codelabs/darrrt/

import 'dart:html';
import 'dart:math' show Random;
import 'dart:convert' show JSON;
import 'dart:async' show Future;

ButtonElement genButton;
SpanElement badgeNameElement;

void main() {
  InputElement inputField = querySelector('#inputName');
  inputField.onInput.listen(updateBadge);
  querySelector('#inputName').onInput.listen(updateBadge); //register a function to handle input events in the input ID
  genButton = querySelector('#generateButton');
  genButton.onClick.listen(generateBadge);
  badgeNameElement = querySelector('#badgeName');
  
  CrimeLordName.readyTheNames()
    .then((_){
      inputField.disabled = false;
      genButton.disabled = false;;
    })
    .catchError((arr){
      print ('There was an error with getting the names ready: $arr');
      badgeNameElement.text = "No name available";
    });
}

void updateBadge(Event e){
  String inputName = (e.target as InputElement).value;
  setBadgeName(new CrimeLordName(firstName: inputName));
  if(inputName.trim().isEmpty){
    genButton..disabled = false
              ..text = 'Hey, give me a name';
  }
  else{
    genButton..disabled = true
        ..text = "Cool, you have a name";
  }
}

void setBadgeName(CrimeLordName newName){
  querySelector('#badgeName').text = newName.crimeLordName;
}

void generateBadge(Event e){
  //querySelector('#inputName').value = new CrimeLordName();
  setBadgeName(new CrimeLordName());
}

class CrimeLordName{
  //private variables start with _
  static final Random indexGen = new Random();
  String _firstName;
  String _appellation;
  String _lastName;
  
  static List<String> names =[];
  
  static List<String> appellations = [];
  
  static List<String> lastNames = [];
  
  static Future readyTheNames(){
    var path = 'crimelordnames.json';
    return HttpRequest.getString(path).then(_parseCrimeLordNameFromJSON);
  }
  
  static _parseCrimeLordNameFromJSON(String jsonString){
    Map crimelordnames = JSON.decode(jsonString);
    names = crimelordnames['firstNames'];
    appellations = crimelordnames['appellations'];
    lastNames = crimelordnames['lastNames'];
  }
  
  
  //constructor (same name as class)
  CrimeLordName({String firstName, String appellation, String lastName}){
    if(firstName == null){
      _firstName = names[indexGen.nextInt(names.length)];
    } else {
      _firstName = firstName;
    }
    
    if(appellation == null){
      _appellation = appellations[indexGen.nextInt(appellations.length)];
    } else {
      _appellation = appellation;
    }
    
    if(lastName == null){
      _lastName = lastNames[indexGen.nextInt(lastNames.length)];
    } else {
      _lastName = lastName;
    }
    
  }
  
  //getter method
  String get crimeLordName =>
      _firstName.isEmpty ? '': "$_firstName '$_appellation' $_lastName";
}

