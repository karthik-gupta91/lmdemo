# lmdemo

To display the list of most viewed articles retrieved from API.

## Requirements

iOS 13.1+ 
Xcode 11.1+
Swift 5+

## Installation

* Download the project.Unarchive the file
* Open Terminal 
* Run the project in any iPhone Simulator. 

## Code Style

This repository is written in swift 5 (latest swift version) and architecture design used is based on VIPER(View,Interactor,Presenter,Entity/Model,Router).  

## Why VIPER?

- Easy to iterate on
- Collaboration friendly
- Separated out concerns
- Spec-ability

### VIPER diagram overview
![](/assets/viper_diagram.png)
### Description:
* View is responsible for receiving user actions, for example: pull to refresh, scroll to bottom, did select row and update view.
* Presenter is responsible to ask interactor for fetching data online or offline, responsible to update the delivery list view and responsible to tell router to do transition to delivery detail view.
* Interactor is responsible for fetching the data online from server and offline from coredata and notify the presenter with updated result.
* Router is responsible to present delivery detail view with data.
* Entity is responsible for decoding the data from network and coredata and provide the usable data to interactor.

## Assumptions

* I assumed that list would be better displayed in the portrait mode. As we are not displaying many things it would be better if we make it for "iPhone Portrait mode" only
* I assumed that list depends on time period, Only displaying list for last one day, For week and month list could be implemented in future.

## Implementations

* App will try to retrieve the data, In case of success list will be shown on the screen, if it fails,Alert will be shown to try again.
* On clicking on every article, detail will be shown.


## Running the tests

Unit test cases are implemented without using any framework. Mock classes are written in order to execute the test cases for different test files. Saving the information in local variable(InputCallbackResults) of Mock classes in order to verify/assert the case.

### Execution of test cases
* Go to Product Tab > Scheme > Select Edit Scheme
* Select Test > Choose option > Select Code Coverage
* Now close the scheme.
* To run test cases press CMD+U
* CMD+9 to check the code coverage, Logs

```
For Example:

private var presenter: MockNYLPresenter!
private var remoteClient: MockNYLRemoteClient!
var interactor: NYListInterator!

override func setUp() {
    presenter = MockNYLPresenter()
    remoteClient = MockNYLRemoteClient()
    interactor = NYListInterator(presenter, remoteClient)
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

func testFetchDataWhenError() {
    remoteClient.error = APIResponseError.requestFailed
    interactor.fetchData("1")
    XCTAssertTrue(presenter.inputCallbackResults["Error"] == APIResponseError.requestFailed.errorDescription)
}

```
### Explanation of test cases
* Arrange - First we are setting up our main test file. In order to test the interator class we need to mainly interact with Network & Presenter. we have mocked these test classes or their protocol for testing purpose.In the first line of test case, we are overriding the error in mockRemoteclient. 

* Act - Finally we are calling our method under test.

* Assert - Verifying if presenter method got a call on error method of mock class by checking the variable set in that method.

