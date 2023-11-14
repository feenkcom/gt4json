Extension { #name : #NeoJSONMapper }

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONMapper >> gtViewMappingsFor: aView [ 
	<gtView>
	
	^ aView columnedList 
		title: 'Mappings';
		items: [ 
			mappings 
				ifNil: [ #() ]
				ifNotNil: [ mappings associations] ];
		column: 'Name' text: [ :assoc | assoc key ];
		column: 'Type' text: [ :assoc | assoc value className ];
		send: [ :assoc | assoc value ]
]
