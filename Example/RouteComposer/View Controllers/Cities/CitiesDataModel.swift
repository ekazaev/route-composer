//
// RouteComposer
// CitiesDataModel.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

class CitiesDataModel {

    @MainActor static var cities = [
        (cityId: 1, city: "Dublin", description: "Dublin, capital of the Republic of Ireland, is on Ireland’s east " +
            "coast at the mouth of the River Liffey. Its historic buildings include Dublin Castle, dating to the" +
            " 13th century, and imposing St Patrick’s Cathedral, founded in 1191. City parks include landscaped " +
            "St Stephen’s Green and huge Phoenix Park, containing Dublin Zoo. The National Museum of Ireland " +
            "explores Irish heritage and culture."),
        (cityId: 2, city: "New York", description: "New York City comprises 5 boroughs sitting where the Hudson " +
            "River meets the Atlantic Ocean. At its core is Manhattan, a densely populated borough that’s among" +
            " the world’s major commercial, financial and cultural centers. Its iconic sites include skyscrapers " +
            "such as the Empire State Building and sprawling Central Park. Broadway theater is staged in neon-lit" +
            " Times Square."),
        (cityId: 3, city: "Los Angeles", description: "Los Angeles is a sprawling Southern California city and the " +
            "center of the nation’s film and television industry. Near its iconic Hollywood sign, studios such as" +
            " Paramount Pictures, Universal and Warner Brothers offer behind-the-scenes tours. On Hollywood " +
            "Boulevard, TCL Chinese Theatre displays celebrities’ hand- and footprints, the Walk of Fame " +
            "honors thousands of luminaries and vendors sell maps to stars’ homes."),
        (cityId: 4, city: "Limerick", description: "Limerick is a major city in the Republic of Ireland, set in " +
            "Munster province in the south of the country. Its compact old town is known for the medieval-era " +
            "St. Mary’s Cathedral and St. John’s square, which is lined with Georgian townhouses. Standing " +
            "along the River Shannon, the 13th-century King John’s Castle is one of the city’s most recognisable" +
            " sites."),
        (cityId: 5, city: "Cork", description: "Cork, just inland from Ireland’s southwest coast, is a university" +
            " city with its centre on an island in the River Lee, connected to the sea by Cork Harbour. The " +
            "castlelike 1824 Cork City Gaol once held prisoners bound for Australia, and exhibitions relay the " +
            "building’s history. The hilltop steeple of 18th-century Shandon Church (officially the Church of " +
            "Saint Anne) is a symbol of the city."),
        (cityId: 6, city: "Galway", description: "Galway, a harbour city on Ireland’s west coast, sits where the " +
            "River Corrib meets the Atlantic Ocean. The city’s hub is 18th-century Eyre Square, a popular " +
            "meeting spot surrounded by shops and traditional pubs that often offer live Irish folk music. " +
            "Nearby, stone-clad cafes, boutiques and art galleries line the winding lanes of the Latin " +
            "Quarter, which retains portions of the medieval city walls."),
        (cityId: 7, city: "San Francisco", description: "San Francisco, in northern California, is a hilly city on " +
            "the tip of a peninsula surrounded by the Pacific Ocean and San Francisco Bay. It's known for its " +
            "year-round fog, iconic Golden Gate Bridge, cable cars and colorful Victorian houses. The Financial" +
            " District's Transamerica Pyramid is its most distinctive skyscraper. In the bay sits Alcatraz " +
            "Island, site of the notorious former prison."),
        (cityId: 8, city: "Washington, DC", description: "Washington, DC, the U.S. capital, is a compact city on " +
            "the Potomac River, bordering the states of Maryland and Virginia. It’s defined by imposing " +
            "neoclassical monuments and buildings – including the iconic ones that house the federal " +
            "government’s 3 branches: the Capitol, White House and Supreme Court. It's also home to iconic " +
            "museums and performing-arts venues such as the Kennedy Center."),
        (cityId: 9, city: "Samarkand", description: "Samarkand is a city in Uzbekistan known for its mosques and" +
            " mausoleums. It's on the Silk Road, the ancient trade route linking China to the Mediterranean." +
            " Prominent landmarks include the Registan, a plaza bordered by 3 ornate, majolica-covered madrassas " +
            "dating to the 15th and 17th centuries, and Gur-e-Amir, the towering tomb of Timur (Tamerlane), " +
            "founder of the Timurid Empire."),
        (cityId: 10, city: "Bukhara", description: "Bukhara is an ancient city in the central Asian country of " +
            "Uzbekistan. It was a prominent stop on the Silk Road trade route between the East and the West, " +
            "and a major medieval center for Islamic theology and culture. It still contains hundreds of " +
            "well-preserved mosques, madrassas, bazaars and caravanserais, dating largely from the 9th " +
            "to the 17th centuries."),
        (cityId: 11, city: "Khiva", description: "Khiva is a city of approximately 50,000 people located in Xorazm " +
            "Region, Uzbekistan. According to archaeological data, the city was established in the beginning of " +
            "the Christian era. It is the former capital of Khwarezmia and the Khanate of Khiva."),
        (cityId: 12, city: "Paris", description: "Paris, France's capital, is a major European city and a global " +
            "center for art, fashion, gastronomy and culture. Its 19th-century cityscape is crisscrossed by " +
            "wide boulevards and the River Seine. Beyond such landmarks as the Eiffel Tower and the " +
            "12th-century, Gothic Notre-Dame cathedral, the city is known for its cafe culture and designer " +
            "boutiques along the Rue du Faubourg Saint-Honoré."),
        (cityId: 13, city: "London", description: "London, the capital of England and the United Kingdom, is a " +
            "21st-century city with history stretching back to Roman times. At its centre stand the imposing " +
            "Houses of Parliament, the iconic ‘Big Ben’ clock tower and Westminster Abbey, site of British " +
            "monarch coronations. Across the Thames River, the London Eye observation wheel provides " +
            "panoramic views of the South Bank cultural complex, and the entire city."),
        (cityId: 14, city: "Amsterdam", description: "Amsterdam is the Netherlands’ capital, known for its artistic" +
            " heritage, elaborate canal system and narrow houses with gabled facades, legacies of the city’s" +
            " 17th-century Golden Age. Its Museum District houses the Van Gogh Museum, works by Rembrandt " +
            "and Vermeer at the Rijksmuseum, and modern art at the Stedelijk. Cycling is key to the city’s " +
            "character, and there are numerous bike paths."),
        (cityId: 15, city: "Berlin", description: "Berlin, Germany’s capital, dates to the 13th century. Reminders" +
            " of the city's turbulent 20th-century history include its Holocaust memorial and the Berlin Wall's" +
            " graffitied remains. Divided during the Cold War, its 18th-century Brandenburg Gate has become " +
            "a symbol of reunification. The city's also known for its art scene and modern landmarks like the " +
            "gold-colored, swoop-roofed Berliner Philharmonie, built in 1963.")
    ]

}
