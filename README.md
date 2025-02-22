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

``bash
curl -X  GET "https://jsonplaceholder.typicode.com/posts?_page=1&_limit=20"
``

The response will be a JSON as below

``json
{
  id: 1,
  title: '...',
  body: '...',
  userId: 1
}
``

## What can be improved
- When a network error occurs, trigger last failed request when connection is established.
- Implement sqflite versioning to allow migration in the future. 

## Dependencies et all