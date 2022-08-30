Extension { #name : #String }

{ #category : #'*GToolkit4Json' }
String >> gtJsonValueDisplayText [
	^ self gtDisplayText
]

{ #category : #'*GToolkit4Json' }
String >> gtRawJsonFor: aView context: aContext [

	^ aView forward
		  title: 'JSON Object';
		  priority: 1;
		  object: [ self ];
		  view: #gtStringFor:
]
