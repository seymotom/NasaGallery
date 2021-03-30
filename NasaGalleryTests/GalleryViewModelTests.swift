//
//  NasaImageTests.swift
//  NasaGalleryTests
//
//  Created by Tom Seymour on 3/30/21.
//

import XCTest
@testable import NasaGallery

extension XCTestCase {
    /**
     Fetches a JSON file
     
     - Parameter name: Optional `String` which can contain the name of a particular file,
       defaults to nil with the class name assumed as the JSON file name
     
     - Returns: `Data`
     
     */
    static func mockData(withName name: String) throws -> Data {
        let bundles = Bundle.allBundles.filter { bundle -> Bool in
            guard bundle.url(forResource: name, withExtension: "json") != nil else {
                return false
            }
            return true
        }
        return try Data(contentsOf: bundles[0].url(forResource: name, withExtension: "json")!)
    }
}

class GalleryViewModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchAndModelDecoding() {
        let testCollectionData = try! XCTestCase.mockData(withName: "NasaCollection")
        let galleryViewModel = GalleryViewModel()
        
        XCTAssertNil(galleryViewModel.items)
        XCTAssertTrue(galleryViewModel.nextPageUrl == "https://images-api.nasa.gov/search?q=space&media_type=image")
        
        galleryViewModel.fetchItems(testData: testCollectionData)
        XCTAssertTrue(galleryViewModel.items!.count == 100)
        XCTAssertTrue(galleryViewModel.nextPageUrl == "https://images-api.nasa.gov/search?q=space&media_type=image&page=2")
        
        let firstItem = galleryViewModel.items!.first!
        let firstItemViewModel = galleryViewModel.itemViewModel(for: firstItem)
        
        XCTAssertTrue(firstItemViewModel.title == firstItem.title)
        XCTAssertTrue(firstItemViewModel.description == firstItem.description)
        
        // testing that viewModels are cached and not created everytime
        let cachedItemViewModel = galleryViewModel.itemViewModel(for: firstItem)
        XCTAssertTrue(firstItemViewModel === cachedItemViewModel)
        XCTAssertTrue(galleryViewModel.itemViewModel(for: 0) === cachedItemViewModel)
        
        let testImageCollection = try! XCTestCase.mockData(withName: "NasaImageUrls")
        let testMetaData = try! XCTestCase.mockData(withName: "NasaMeta")
        firstItemViewModel.fetchFullImageMetaData(testCollectionData: testImageCollection, testMetaData: testMetaData)
        
        XCTAssertTrue(firstItemViewModel.photographer == "Photographer: Vinny Oakerson")
        XCTAssertTrue(firstItemViewModel.location == "Location: Queens")
    }

}
