Extension { #name : #Collection }

{ #category : #'*GToolkit4Json' }
Collection >> gtRawJsonFor: aView context: aContext [

	^ aView forward
		  title: 'JSON Object';
		  priority: 1;
		  object: [ self ];
		  view: #gtTreeFor:context:
]
