//
//  CoreDataHelper.swift
//  Pokemon
//
//  Created by Michael Zhou on 2018-07-15.
//  Copyright © 2018 Michael Zhou. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon() {
    createPokemon(name: "Mew", image: "mew")
    createPokemon(name: "Meowth", image: "meowth")
    createPokemon(name: "Pikachu", image: "pikachu-2")
    createPokemon(name: "Bulbasaur", image: "bulbasaur")
    createPokemon(name: "Charmander", image: "charmander")
    createPokemon(name: "Squirtle", image: "squirtle")
    createPokemon(name: "Mankey", image: "mankey")
    createPokemon(name: "Weedle", image: "weedle")
    createPokemon(name: "Snorlax", image: "snorlax")
    createPokemon(name: "Pidgey", image: "pidgey")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let pokemon = Pokemon(context: context)
    pokemon.name = "Rattata"
    pokemon.image = "rattata"
    pokemon.isCaught = true
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func createPokemon(name: String, image: String) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.image = image
}

func getAllPokemon() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        if pokemons.count == 0 {
            addAllPokemon()
            return getAllPokemon()
        }
        return pokemons
    } catch {}
    return []
}

func getAllCaughtPokemons() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
        print("Caught:")
        var pokemons : [Pokemon] = []
        for pokemon in try context.fetch(Pokemon.fetchRequest()) as! [Pokemon] {
            if pokemon.isCaught {
                pokemons.append(pokemon)
                print(pokemon.name!)
            }
        }
        return pokemons
    } catch {}
    return []
}

func getAllUncaughtPokemons() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
        print("Uncaught:")
        var pokemons : [Pokemon] = []
        for pokemon in try context.fetch(Pokemon.fetchRequest()) as! [Pokemon] {
            if !(pokemon.isCaught) {
                pokemons.append(pokemon)
                print(pokemon.name!)
            }
        }
        return pokemons
    } catch {}
    return []
}
