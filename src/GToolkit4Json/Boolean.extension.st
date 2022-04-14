Extension { #name : #Boolean }

{ #category : #'*GToolkit4Json' }
Boolean >> gtRawJsonFor: aView context: aContext [

	^ aView forward
		  title: 'JSON Object';
		  priority: 1;
		  object: [ self ];
		  view: #gtLiveFor:
]
