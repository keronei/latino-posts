# Latino Posts

A simple project to showcase REST API with Offline Functionality

## Screenshots

## Getting Started

Ensure your flutter environment is setup (use the official guide [here](https://docs.flutter.dev/get-started/install/macos/mobile-android)), then clone this project:

Open with your favourite editor, let it sync to completion. 
Alternatively, you can grab this APK and run in on your Android device.

## The Architecture

## About the API
This app uses fake API from [JSON Placeholder](https://jsonplaceholder.typicode.com), the documentation can be found at [JSON Placeholder guide](https://jsonplaceholder.typicode.com/guide).

To achieve pagination, use query param `_page` to select a page you want to request with `_limit` to cap the number of items per page.

An example of a request to get first page of 20 posts would be:

```bash

curl -X  GET "https://jsonplaceholder.typicode.com/posts?_page=1&_limit=20"

```

The response will be a JSON as below

```json
{
  "id": 1,
  "title": "String title goes here",
  "body": "Body of the post",
  "userId": 1
}
```

## What can be improved
- When a network error occurs, trigger last failed request when connection is established.
- Implement sqflite versioning to allow migration in the future. 
- Add UI tests to verify UI behaviour under various interactions

## Dependencies et all

| Package                                                 | Purpose                                                   |       
|---------------------------------------------------------|-----------------------------------------------------------|
| [http](https://pub.dev/packages/http)                   | For taking care of http requests                          |        
| [path_provider](https://pub.dev/packages/path_provider) | Handle locations on the system - specifically for db file |
| [path](https://pub.dev/packages/path)                   | Enables manipulating various paths                        |
| [sqflite](https://pub.dev/packages/sqflite)             | For storing the posts on device.                          |
| [test](https://pub.dev/packages/test)                   | Assist in verifying behaviour an unit level               |
| [provider](https://pub.dev/packages/provider)| To "inject" class instances instead of re-initiation
| [Mocktail](https://pub.dev/packages/mocktail)| Create mocks with less boilerplate and faster writing of tests