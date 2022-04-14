Extension { #name : #UndefinedObject }

{ #category : #'*GToolkit4Json' }
UndefinedObject >> gtRawJsonFor: aView context: aContext [

	^ aView forward
		  title: 'JSON Object';
		  priority: 1;
		  object: [ self ];
		  view: #gtLiveFor:
]
