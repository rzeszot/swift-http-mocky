import Foundation

struct Actor: Codable {
    let name: String

    static var depp: Actor {
        .init(name: "Johnny Depp")
    }
}

extension Fixture {
    static let actors: Fixture = """
    [
      {
        "name" : "Tom Hanks"
      },
      {
        "name" : "Will Smith"
      },
      {
        "name" : "Samuel L. Jackson"
      },
      {
        "name" : "Leonardo Di Caprio"
      }
    ]
    """

    static let depp: Fixture = """
    {
      "name" : "Johnny Depp"
    }
    """
}
