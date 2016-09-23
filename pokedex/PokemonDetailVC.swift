//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by SimpuMind on 9/22/16.
//  Copyright © 2016 SimpuMind. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokeman!
    
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var defenseLabl: UILabel!
    @IBOutlet var attackLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var pokedexLabel: UILabel!
    @IBOutlet var evolutionLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var mainImg: UIImageView!
    @IBOutlet var currentEvolution: UIImageView!
    @IBOutlet var nextEvolutionImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let img = UIImage(named: "\(pokemon.pokedexId)")
        let pokeId = pokemon.pokedexId - 1
        nameLabel.text  = pokemon.name
        mainImg.image = img
        pokedexLabel.text = "\(pokeId)"
        currentEvolution.image = img
        
        pokemon.downPokemonDetails {
            self.updateUI()
        }
    }
    
    func updateUI(){
        descriptionLabel.text = pokemon.description
        typeLabel.text = pokemon.type
        defenseLabl.text = pokemon.defense
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        attackLabel.text = pokemon.attack
        
        if pokemon.nextEvolutionID == ""{
            evolutionLabel.text = "no Evolutions"
            nextEvolutionImg.isHidden = true
        }else{
            nextEvolutionImg.isHidden = true
            nextEvolutionImg.image = UIImage(named: pokemon.nextEvolutionID)
            var str = "Next Evolution: \(pokemon.nextEvolutionText)"
            
            if pokemon.nextEvolutionLvl != ""{
                str += " - LVL \(pokemon.nextEvolutionLvl)"
            }
        }
    }

    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }


}
