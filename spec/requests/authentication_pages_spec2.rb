require 'spec_helper'

describe "authentication" do
	subject { page }
	let(:user) { FactoryGirl.create(:user) }
	let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
	let(:non_admin) { FactoryGirl.create(:user) }
	let(:submit) { "Sign in" }

	describe "signin page" do
		before { visit signin_path }

		it { should have_selector('h1', text: 'Sign in') }
		it { should have_selector('title', text: 'Sign in') }

		it "should not have links to signed in functions" do
			should_not have_link('Profile', href: user_path(user))
			should_not have_link('Settings', href: user_path(user))
		end
	end

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button submit }

			it { should have_selector('title', text: 'Sign in') }
			it { should have_selector('div.alert.alert-error', text: 'Invalid') }

			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end

		end

		describe "with valid information" do
			before { sign_in user }

			it { should have_selector('title', text: user.name) }
			it { should have_link('Users',    href: users_path) }
			it { should have_link('Profile', href: user_path(user)) }
			it { should have_link('Settings', 	href: edit_user_path(user)) }
			it { should have_link('Sign out', href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }
		end
	end

	describe "authorisation" do

		describe "as non-admin user" do
			before { sign_in non_admin }

			describe "submitting a DELETE request to the Users#destroy action" do
				before { delete user_path(user) }
				specify { response.should redirect_to(root_path) }        
			end
		end

		describe "for non-sign-in users" do
			let(:user) {FactoryGirl.create(:user)}

			describe "in the Relationships controller" do
				describe "submitting to the create action" do
					before {post relationships_path}
					specify {response.should redirect_to(signin_path)}
				end

				describe "submitting to the destroy action" do
					before {delete relationship_path(1)}
					specify {response.should redirect_to(signin_path)}
				end
			end

			describe "in the Users controller" do

				describe "visiting the following page" do
					before { visit following_user_path(user)}
					it {should have_selector('title', text: 'Sign in')}
				end

				describe "visiting the followers page" do
					before { visit followers_user_path(user)}
					it {should have_selector('title', text: 'Sign in')}
				end

				describe "visiting the index page" do
					before { visit users_path }
					it { should have_selector('title', text: 'Sign in') }
				end

				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_selector('title', text: 'Sign in') }
				end

				describe "submitting to the update action" do
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path)}
				end

				describe "when attempting to visit a protected page" do
					before do
						visit edit_user_path(user)
						fill_in "Email",    with: user.email
						fill_in "Password", with: user.password
						click_button "Sign in"
					end

					describe "after signing in" do

						it "should render the desired protected page" do
							page.should have_selector('title', text: 'Edit user')
						end

						describe "when signing in again" do
							before do
								visit signin_path
								fill_in "Email",    with: user.email
								fill_in "Password", with: user.password
								click_button "Sign in"
							end

							it "should render the default (profile) page" do
								page.should have_selector('title', text: user.name) 
							end
						end
					end
				end
			end

			describe "in the Microposts controller" do

				describe "submitting to the create action" do
					before { post microposts_path }
					specify { response.should redirect_to(signin_path)}
				end

				describe "submitting to the destroy action" do
					before do
						micropost = FactoryGirl.create(:micropost)
						delete micropost_path(micropost)
					end
					specify { response.should redirect_to(signin_path) }
				end
			end

		end

		describe "as wrong user" do
			before { sign_in user }

			describe "visiting Users#edit page" do
				before { visit edit_user_path(wrong_user) }
				it { should_not have_selector('title', text: full_title('Edit user')) }
			end

			describe "submitting a put request to the Users#update action" do
				before { put user_path(wrong_user) }
				specify { response.should redirect_to(root_path) }
			end
		end
	end
end