//
//  ViewController.swift
//  pokedex
//
//  Created by SimpuMind on 9/22/16.
//  Copyright © 2016 SimpuMind. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate,
                    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
                    UISearchBarDelegate{

    @IBOutlet weak var collection:UICollectionView!
    @IBOutlet weak var searchPokemon: UISearchBar!
    
    var musicPlayer: AVAudioPlayer!
    var isInSearchMode = false
    var filterPokemon = [Pokeman]()
    var pokemon = [Pokeman]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchPokemon.delegate = self
        searchPokemon.returnKeyType = UIReturnKeyType.done
        
        initAudio()
        
        parsePokemonCSV()
    }
    
    func initAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do{
            musicPlayer = try AVAudioPlayer(contentsOf: NSURL(string: path)! as URL)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV(){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do{
            let csv = try? CSV(contentsOfURL: path)
            let rows = csv?.rows
            for  row in rows!{
                let pokeId = Int(row["id"]!)!
                let nam = row["identifier"]!
                
                let poke = Pokeman(name: nam, pokedexId: pokeId)
                 pokemon.append(poke)
            }
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            
            //let poke = pokemon[indexPath.row]
            let poke: Pokeman!
            if isInSearchMode{
                poke = filterPokemon[indexPath.row]
            }else{
                poke = pokemon[indexPath.row]
            }
            cell.configureCell(pokemon: poke)
            
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isInSearchMode{
            return filterPokemon.count
        }
        return pokemon.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isInSearchMode = false
            view.endEditing(true)
            collection.reloadData()
        }else{
            isInSearchMode = true
            let lower = searchBar.text!.lowercased()
            filterPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
        }
    }
    

    @IBAction func musicButtonPress(_ sender: UIButton!) {
        if  musicPlayer.isPlaying{
            musicPlayer.stop()
            sender.alpha = 0.2
        }else{
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
}

