Class {
	#name : #GtJsonModelExamples,
	#superclass : #Object,
	#category : #'GToolkit4Json-Examples'
}

{ #category : #accessing }
GtJsonModelExamples >> emptyDateAndTimeModel [

	<gtExample>
	| aModel |
	aModel := GtJsonDateAndTimeModel new.

	self assert: aModel isValid not.

	^ aModel
]

{ #category : #accessing }
GtJsonModelExamples >> invalidDateAndTimeModel [

	<gtExample>
	| aModel |
	aModel := GtJsonDateAndTimeModel forJsonString:
		          '"2010-01-01T19:73:24Z"'.

	self assert: aModel isValid not.

	^ aModel
]

{ #category : #accessing }
GtJsonModelExamples >> missingDateAndTimeModel [

	<gtExample>
	| aModel aRootJson aDateJson |
	aRootJson := GtJson forJsonObject: #() asDictionary.
	aDateJson := aRootJson at: #date.

	aModel := GtJsonDateAndTimeModel forJson: aDateJson.

	self assert: aModel isValid not.

	^ aModel
]

{ #category : #accessing }
GtJsonModelExamples >> validDateAndTimeModel [

	<gtExample>
	| aModel |
	aModel := GtJsonDateAndTimeModel forJsonString:
		          '"2010-01-01T19:53:24Z"'.

	self assert: aModel isValid.

	^ aModel
]
