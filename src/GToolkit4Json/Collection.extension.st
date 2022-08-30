Extension { #name : #Collection }

{ #category : #'*GToolkit4Json' }
Collection >> gtJsonValueDisplayText [
	^ self size gtDisplayText
		append: (' item' asPluralBasedOn: self size) gtDisplayText;
		foreground: BrGlamorousColors disabledButtonTextColor
]

{ #category : #'*GToolkit4Json' }
Collection >> gtRawJsonFor: aView context: aContext [

	^ aView forward
		  title: 'JSON Object';
		  priority: 1;
		  object: [ self ];
		  view: #gtTreeFor:context:
]
