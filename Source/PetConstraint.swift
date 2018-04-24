// Created by 程巍巍 on 2018/04/23.
// Copyright © 2018年 程巍巍. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//     http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License. 

import Foundation
import UIKit

public struct PetConstraint
{

  public struct Pet
  {
    let view: UIView

    init(_ host: UIView)
    {
      self.view = host
    }

    public var left: Constraint { return Constraint(view, .left) }
    public var right: Constraint { return Constraint(view, .right) }
    public var top: Constraint { return Constraint(view, .top) }
    public var bottom: Constraint { return Constraint(view, .bottom) }
    public var leading: Constraint { return Constraint(view, .leading) }
    public var trailing: Constraint { return Constraint(view, .trailing) }
    public var width: Constraint { return Constraint(view, .width) }
    public var height: Constraint { return Constraint(view, .height) }
    public var centerX: Constraint { return Constraint(view, .centerX) }
    public var centerY: Constraint { return Constraint(view, .centerY) }
  }

  public struct Constraint
  {
    let view: UIView
    let attribute: NSLayoutAttribute
    let constant: CGFloat
    let multiplier: CGFloat

    init(_ view: UIView,
         _ attribute: NSLayoutAttribute,
         constant: CGFloat = 0,
         multiplier: CGFloat = 1)
    {
      self.view = view
      self.attribute = attribute
      self.constant = constant
      self.multiplier = multiplier
    }

    func apply(relation: NSLayoutRelation, constant: CGFloat)
    {
      view.translatesAutoresizingMaskIntoConstraints = false
      view.addConstraint(NSLayoutConstraint(
        item: view,
        attribute: attribute,
        relatedBy: relation,
        toItem: nil,
        attribute: .notAnAttribute,
        multiplier: 1,
        constant: constant
      ))
    }

    func apply(relation: NSLayoutRelation, other: Constraint)
    {
      view.translatesAutoresizingMaskIntoConstraints = false
      other.view.translatesAutoresizingMaskIntoConstraints = false
      findAnchor(other.view)?.addConstraint(NSLayoutConstraint(
        item: view,
        attribute: attribute,
        relatedBy: relation,
        toItem: other.view,
        attribute: other.attribute,
        multiplier: other.multiplier,
        constant: other.constant
      ))
    }

    private func findAnchor(_ other: UIView)-> UIView?
    {
      if view.isDescendant(of: other) { return other }
      if other.isDescendant(of: view) { return view }

      var anchor: UIView? = other
      while anchor != nil {
        anchor = anchor?.superview
        if anchor == nil {
          NSLog("No parent view found:\n%@\n%@", view, other);
          return anchor
        }
        if view.isDescendant(of: anchor!) {
          return anchor?.superview
        }
      }
      return anchor
    }
  }
}

public func *(pet: PetConstraint.Constraint, multiplier: CGFloat)-> PetConstraint.Constraint
{
  return PetConstraint.Constraint(pet.view, pet.attribute, constant: pet.constant, multiplier: multiplier)
}

public func /(pet: PetConstraint.Constraint, multiplier: CGFloat)-> PetConstraint.Constraint
{
  return PetConstraint.Constraint(pet.view, pet.attribute, constant: pet.constant, multiplier: 1/multiplier)
}

public func +(pet: PetConstraint.Constraint, constant: CGFloat)-> PetConstraint.Constraint
{
  return PetConstraint.Constraint(pet.view, pet.attribute, constant: constant, multiplier: pet.multiplier)
}

public func -(pet: PetConstraint.Constraint, constant: CGFloat)-> PetConstraint.Constraint
{
  return PetConstraint.Constraint(pet.view, pet.attribute, constant: -constant, multiplier: pet.multiplier)
}

public func ==(pet: PetConstraint.Constraint, constant: CGFloat)
{
  pet.apply(relation: .equal, constant: constant)
}
public func >=(pet: PetConstraint.Constraint, constant: CGFloat)
{
  pet.apply(relation: .greaterThanOrEqual, constant: constant)
}
public func <=(pet: PetConstraint.Constraint, constant: CGFloat)
{
  pet.apply(relation: .lessThanOrEqual, constant: constant)
}

public func ==(pet: PetConstraint.Constraint, other: PetConstraint.Constraint)
{
  pet.apply(relation: .equal, other: other)
}
public func >=(pet: PetConstraint.Constraint, other: PetConstraint.Constraint)
{
  pet.apply(relation: .greaterThanOrEqual, other: other)
}
public func <=(pet: PetConstraint.Constraint, other: PetConstraint.Constraint)
{
  pet.apply(relation: .lessThanOrEqual, other: other)
}

//
public extension UIView {
  public var pet: PetConstraint.Pet { return PetConstraint.Pet(self) }
}
