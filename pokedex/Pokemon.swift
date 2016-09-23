//
//  Pokemon.swift
//  pokedex
//
//  Created by SimpuMind on 9/22/16.
//  Copyright © 2016 SimpuMind. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Pokeman{
    fileprivate var _name: String!
    fileprivate var _type: String!
    fileprivate var _height: String!
    fileprivate var _weight: String!
    fileprivate var _attack: String!
    fileprivate var _pokedexId: Int!
    fileprivate var _defense: String!
    fileprivate var _pokemonUrl: String!
    fileprivate var _description: String!
    fileprivate var _nextEvolutionId: String!
    fileprivate var _nextEvolutionLvl: String!
    fileprivate var _nextEvolutionText: String!
    
    var name:String{
        return _name
    }
    
    var type:String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var height:String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    var weight:String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    
    var attack:String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    
    var defense:String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    
    var pokedexId:Int{
        return _pokedexId
    }
    
    var description:String{
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
    var nextEvolutionID:String{
        if _nextEvolutionId == nil{
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionText:String{
        
        if _nextEvolutionText == nil{
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var nextEvolutionLvl:String{
        if _nextEvolutionLvl == nil{
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    
    init(name:String, pokedexId:Int) {
        _name = name
        _pokedexId = pokedexId + 1
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(pokedexId)/"
    }
    
    func downPokemonDetails(completed:@escaping DownloadComplete){
        
        let strUtrl = _pokemonUrl!
        Alamofire.request(strUtrl).responseJSON { response in
            
            let json = JSON(data: response.data!)
            
            if let dict = json.dictionaryObject{
                if let weight = dict["weight"] as? String{
                    self._weight = "\(weight)"
                }else{
                    print("Did not get to weight")
                }
                
                if let height = dict["height"] as? String{
                    self._height = "\(height)"
                }else{
                    print("Did not get to height")
                }
                if let attack = dict["attack"] as? Int{
                    self._attack = "\(attack)"
                }else{
                    print("Did not get to attack")
                }
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }else{
                    print("Did not get to defense")
                }
                if let types = dict["types"] as? [Dictionary<String, String>]{
                    if types.count > 0{
                        if let name = types[0]["name"]{
                            self._type = name
                        }
                        if types.count > 1{
                            for x in 1 ..< types.count {
                                if let name = types[x]["name"]{
                                    self._type! += "/\(name)"
                                }
                            }
                        }
                    }else{
                        self._type = ""
                    }
                }else{
                    print("Did not get to type")
                }
                if let descPr = dict["descriptions"] as? [Dictionary<String, String>]{
                    if descPr.count > 0{
                        if let uri = descPr[0]["resource_uri"]{
                           Alamofire.request( "\(URL_BASE)\(uri)").responseJSON { response in
                               let jso = JSON(data: response.data!)
                                if let desc = jso.dictionaryObject{
                                    
                                    if let descp = desc["description"] as? String{
                                            self._description = descp
                                            print(self._description)
                                    }
                                }
                                completed()
                            }
                        }
                    }else{
                        self._description = ""
                    }
                }else{
                    print("Did not get to description")
                }
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>]{
                    if evolutions.count > 0{
                        if let to = evolutions[0]["to"] as? String{
                            
                            //Mega is not found, i can't support api pokeman mega field right now!
                            if to.range(of: "mega") == nil{
                                if let uri = evolutions[0]["resource_uri"] as? String{
                                    let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                    let num = newString.replacingOccurrences(of: "/", with: "")
                                    self._nextEvolutionId = num
                                    self._nextEvolutionText = to
                                    if let lvl = evolutions[0]["level"] as? Int{
                                        self._nextEvolutionLvl = "\(lvl)"
                                    }
                                    
                                    print(self._nextEvolutionId)
                                    print(self._nextEvolutionText)
                                    print(self._nextEvolutionLvl)
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
}
