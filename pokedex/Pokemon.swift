//
//  Pokemon.swift
//  pokedex
//
//  Created by SimpuMind on 9/22/16.
//  Copyright © 2016 SimpuMind. All rights reserved.
//

import Foundation

class Pokeman{
    private var _name: String!
    private var _pokedexId: Int!
    
    var name:String{
        return _name
    }
    
    var pokedexId:Int{
        return _pokedexId
    }
    
    init(name:String, pokedexId:Int) {
        _name = name
        _pokedexId = pokedexId + 1
    }
}
