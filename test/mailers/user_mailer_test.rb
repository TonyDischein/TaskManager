require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'task created' do
    user = create(:user)
    task = create(:task, author: user)
    params = { user: user, task: task }

    email = UserMailer.with(params).task_created

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ENV['MAILER_USERNAME']], email.from
    assert_equal [user.email], email.to
    assert_equal 'New Task Created', email.subject
    assert email.body.to_s.include?("Task #{task.id} was created")
  end

  test 'task update' do
    user = create(:user)
    task = create(:task, author: user)
    assignee = create(:user)

    task_attributes = attributes_for(:task).
      merge({ author_id: user.id, assignee_id: assignee.id }).
      stringify_keys
    task.update(task_attributes)

    params = { user: user, task: task }
    email = UserMailer.with(params).task_updated

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ENV['MAILER_USERNAME']], email.from
    assert_equal [user.email, assignee.email], email.to
    assert_equal "Task #{task.id} Updated", email.subject
    assert email.body.to_s.include?("Task #{task.id} was updated")
  end

  test 'task deleted' do
    user = create(:user)
    task = create(:task, author: user)
    task.destroy

    params = { user: user, task: task.id }
    email = UserMailer.with(params).task_deleted

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ENV['MAILER_USERNAME']], email.from
    assert_equal [user.email], email.to
    assert_equal "Task #{task.id} Deleted", email.subject
    assert email.body.to_s.include?("Task #{task.id} was deleted")
  end
end
