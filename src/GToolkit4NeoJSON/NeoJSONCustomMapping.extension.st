Extension { #name : #NeoJSONCustomMapping }

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONCustomMapping >> gtViewReaderSourceCodeFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Reader coder';
		priority: 1;
		object: [ reader ];
		view: #gtSourceCodeFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect Block' 
			action: [ :aButton | 
				aButton phlow spawnObject: self ]
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONCustomMapping >> gtViewWriterSourceCodeFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Writer coder';
		priority: 10;
		object: [ writer ];
		view: #gtSourceCodeFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect Block' 
			action: [ :aButton | 
				aButton phlow spawnObject: self ]
]
