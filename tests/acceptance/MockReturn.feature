Feature: MockReturn
  
  Background:
    Given I have the following config
      """
      <?xml version="1.0"?>
      <psalm totallyTyped="true">
        <projectFiles>
          <directory name="."/>
          <ignoreFiles> <directory name="../../vendor"/> </ignoreFiles>
        </projectFiles>
        <plugins>
          <pluginClass class="Psalm\MockeryPlugin\Plugin"/>
        </plugins>
      </psalm>
      """
    And I have the following code preamble
      """
      <?php
      namespace NS;
      use Mockery;
      
      """
    
  Scenario: Defined method mocking sets proper intersection return type
    Given I have the following code
      """
      class User
      {
          /**
           * @return void
           */
          public function someMethod()
          {
          
          }
      }
      
      $user = Mockery::mock('NS\User[someMethod]', []);
      
      if (is_array($user)) {
      
      }
      """
    When I run Psalm
    Then I see these errors
      | Type            | Message                                                                                                                                 |
      | DocblockTypeContradiction | Cannot resolve types for $user - docblock-defined type Mockery\MockInterface&NS\User does not contain array<%, mixed> |
    And I see no other errors
    