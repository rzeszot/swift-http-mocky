import Foundation

struct Actor: Decodable {
  let name: String
}

extension Fixture {
  static let actors: Fixture = """
    [
      {
        "name": "Tom Hanks"
      },
      {
        "name": "Will Smith"
      },
      {
        "name": "Samuel L. Jackson"
      },
      {
        "name": "Leonardo Di Caprio"
      }
    ]
    """
}
