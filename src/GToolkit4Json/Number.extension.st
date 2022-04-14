Extension { #name : #Number }

{ #category : #'*GToolkit4Json' }
Number >> gtRawJsonFor: aView context: aContext [

	^ aView forward
		  title: 'JSON Object';
		  priority: 1;
		  object: [ self ];
		  view: #gtPreviewFor:
]
